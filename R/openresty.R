#' Retrieve openresty Version Release History
#'
#' Reads <https://github.com/openresty/openresty/releases> to build a data frame of
#' openresty version release numbers and dates with pesudo-semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @param refresh if `TRUE` and there `~/.vershist` cache dir exists, will
#'        cause the version history database for apache to be rebuilt. Defaults
#'        to `FALSE` and has no effect if `~/.vershist` cache dir does not exist.
#' @note This function requires a valid GitHub API key stored in `GITHUB_PAT`
#' @export
openresty_version_history <- function(refresh = FALSE) {

  tech <- "openresty"
  if (use_cache() && (!refresh) && is_cached(tech)) return(read_from_cache(tech))

  page <- gh::gh("/repos/openresty/openresty/tags")

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
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels=vers)) %>%
    dplyr::select(vers, rls_date, rls_year, major, minor, patch, prerelease, build) -> out


  if (use_cache() && (refresh || (!is_cached(tech)))) write_to_cache(out, tech)

  out

}