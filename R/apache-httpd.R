#' Retrieve Apache httpd Version Release History
#'
#' Reads <https://github.com/apache/httpd> releases to build a data frame of
#' Apache `httpd` version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @param refresh if `TRUE` and there `~/.vershist` cache dir exists, will
#'        cause the version history database for apache to be rebuilt. Defaults
#'        to `FALSE` and has no effect if `~/.vershist` cache dir does not exist.
#' @export
apache_httpd_version_history <- function(refresh = FALSE) {

  tech <- "apache-httpd"
  if (use_cache() && (!refresh) && is_cached(tech)) return(read_from_cache(tech))

  page <- gh::gh("/repos/apache/httpd/tags")

  purrr::map_df(
    page, ~{
      list(
        vers = .x$name,
        rls_date = gh::gh(.x$commit$url)$commit$author$date # kinda dangerous
      )
    }) -> xdf

  sgh_next <- purrr::safely(gh::gh_next) # to stop on gh_next() error

  while(TRUE) {
    page <- sgh_next(page)
    if (is.null(page$result)) break;
    page <- page$result
    dplyr::bind_rows(
      xdf,
      purrr::map_df(
        page, ~{
          list(
            vers = .x$name,
            rls_date = gh::gh(.x$commit$url)$commit$author$date # kinda dangerous
          )
        })
    ) -> xdf
  }

  suppressWarnings(
    dplyr::mutate(xdf, vers = stri_replace_first_fixed(vers, "v", "")) %>%
      dplyr::mutate(rls_date = as.Date(stri_sub(rls_date, 1, 10))) %>%
      dplyr::mutate(rls_year = lubridate::year(rls_date)) %>%
      tidyr::separate(vers, c("major", "minor", "patch", "build"), remove=FALSE) %>%
      dplyr::mutate(prerelease = ifelse(
        stri_detect_regex(build, "[[:alpha:]]"),
        stri_extract_first_regex(build, "[[:alpha:]][[:alnum:]]+"),
        ""
      )) %>%
      dplyr::mutate(build = stri_replace_first_regex(build, "[[:alpha:]][[:alnum:]]+", "")) %>%
      dplyr::mutate_at(.vars=c("major", "minor", "patch", "build"), .funs=c(as.integer)) %>%
      dplyr::add_row(
        vers = "2.0.0",
        rls_date = as.Date("2001-02-09"),
        rls_year = 2001,
        major = 2L, minor = 0L, patch = 0L,
        prerelease = NA_character_, build = NA
      ) %>%
      dplyr::add_row(
        vers = "1.3.37",
        rls_date = as.Date("2006-07-27"),
        rls_year = 2006,
        major = 1L, minor = 3L, patch = 37L,
        prerelease = NA_character_, build = NA
      ) %>%
      dplyr::add_row(
        vers = "1.3.41",
        rls_date = as.Date("2009-10-03"),
        rls_year = 2009,
        major = 1L, minor = 3L, patch = 41L,
        prerelease = NA_character_, build = NA
      ) %>%
      dplyr::arrange(rls_date) %>%
      dplyr::mutate(vers = factor(vers, levels=vers)) %>%
      dplyr::select(
        vers, rls_date, rls_year, major, minor, patch, prerelease, build
      ) -> out
  )

  if (use_cache() && (refresh || (!is_cached(tech)))) write_to_cache(out, tech)

  out

}