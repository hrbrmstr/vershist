#' Retrieve Exim Version Release History
#'
#' Reads <https://marc.info/?l=exim-announce&r=1&w=2>
#' to build a data frame of Exim version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @param refresh if `TRUE` and there `~/.vershist` cache dir exists, will
#'        cause the version history database for apache to be rebuilt. Defaults
#'        to `FALSE` and has no effect if `~/.vershist` cache dir does not exist.
#' @export
exim_version_history <- function(refresh = FALSE) {

  tech <- "exim"
  if (use_cache() && (!refresh) && is_cached(tech)) return(read_from_cache(tech))

  pg <- xml2::read_html("https://marc.info/?l=exim-announce&r=1&w=2")

  rvest::html_nodes(pg, xpath=".//a[contains(@href, 'exim-ann')]") %>%
    rvest::html_attr("href") %>%
    purrr::keep(grepl("&r=[[:digit:]]+&b=", .)) %>%
    sprintf("https://marc.info/%s", .) %>%
    purrr::map(httr::GET) -> exim_list

  purrr::map(
    exim_list,
    ~httr::content(.x, encoding = "UTF-8") %>%
      rvest::html_nodes("pre") %>%
      rvest::html_text(trim = FALSE) %>%
      stri_split_lines() %>%
      unlist()
  ) %>%
    purrr::flatten_chr() %>%
    purrr::keep(grepl("release", ., ignore.case = TRUE)) %>%
    purrr::discard(grepl("elspy", .)) %>%
    stri_replace_all_fixed("_", ".") -> rls

  dplyr::tibble(
    rls_date = stri_match_first_regex(rls, "([[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2})")[,2],
    vers = stri_match_first_regex(tolower(rls), "\\[exim-announce\\][^[:digit:]]*([[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+|[[:digit:]]+\\.[[:digit:]]+)")[,2]
  ) %>%
    dplyr::filter(!is.na(vers)) %>%
    dplyr::filter(vers != "3.953") %>%
    dplyr::mutate(dots = stri_count_fixed(vers, ".")) %>%
    dplyr::mutate(vers = ifelse(dots == 1, sprintf("%s.0", vers), vers)) %>%
    dplyr::mutate(
      rls_date = as.Date(rls_date),
      year = lubridate::year(rls_date)
    ) %>%
    dplyr::arrange(desc(rls_date)) %>%
    dplyr::distinct(vers, .keep_all = TRUE) %>%
    dplyr::arrange(rls_date) %>%
    tidyr::separate(vers, c("major", "minor", "patch", "prerelease", "build"), sep="\\.", remove = FALSE, fill = "right") %>%
    dplyr::select(vers, rls_date, rls_year = year, major, minor, patch, prerelease, build, -dots) %>%
    dplyr::mutate_at(.vars=c("major", "minor", "patch", "build"), .funs=c(as.integer)) %>%
    dplyr::arrange(rls_date, major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels = vers)) -> out

  page <- gh::gh("/repos/Exim/exim/tags")

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

  dplyr::filter(xdf, stri_detect_regex(vers, "^exim-")) %>%
    dplyr::mutate(vers = stri_replace_first_regex(vers, "^exim-", "")) %>%
    dplyr::filter(!stri_detect_regex(vers, "[[:alpha:]]")) %>%
    dplyr::mutate(vers = stri_replace_all_regex(vers, "([[:digit:]]+)_", "$1.")) %>%
    dplyr::filter(stri_count_fixed(vers, ".") < 3) %>%
    dplyr::mutate(rls_date = as.Date(stri_sub(rls_date, 1, 10))) %>%
    dplyr::mutate(rls_year = lubridate::year(rls_date)) %>%
    tidyr::separate(vers, c("major", "minor", "patch", "build"), remove=FALSE, fill = "right") %>%
    dplyr::mutate(prerelease = ifelse(
      stri_detect_regex(build, "[[:alpha:]]"),
      stri_extract_first_regex(build, "[[:alpha:]][[:alnum:]]+"),
      ""
    )) %>%
    dplyr::mutate(build = stri_replace_first_regex(build, "[[:alpha:]][[:alnum:]]+", "")) %>%
    dplyr::mutate_at(.vars=c("major", "minor", "patch", "build"), .funs=c(as.integer)) %>%
    dplyr::mutate_at(vars(major, minor, patch), ~ifelse(is.na(.), 0, .)) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = sprintf("%s.%s.%s", major, minor, patch)) %>%
    dplyr::select(vers, rls_date, rls_year, major, minor, patch, prerelease, build) -> from_gh

  dplyr::bind_rows(
    mutate(out, vers = as.character(vers)),
    filter(from_gh, !(vers %in% out$vers))
  ) %>%
  dplyr::arrange(rls_date, major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels = vers)) -> out

  if (use_cache() && (refresh || (!is_cached(tech)))) write_to_cache(out, tech)

  out

}



