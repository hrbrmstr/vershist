#' Retrieve Google Chrome Version Release History
#'
#' Reads <https://en.wikipedia.org/wiki/Google_Chrome_version_history"> to build a data
#' frame of Google Chrome version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @param refresh if `TRUE` and there `~/.vershist` cache dir exists, will
#'        cause the version history database for apache to be rebuilt. Defaults
#'        to `FALSE` and has no effect if `~/.vershist` cache dir does not exist.
#' @note This _only_ pulls the first release date and does not distinguish by OS.
#'       If more granular data is needed, file an issue or PR.
#' @export
google_chrome_version_history <- function(refresh = FALSE) {

  tech <- "google-chrome"
  if (use_cache() && (!refresh) && is_cached(tech)) return(read_from_cache(tech))

  pg <- xml2::read_html("https://en.wikipedia.org/wiki/Google_Chrome_version_history")

  dplyr::data_frame(
    vers = rvest::html_nodes(pg, xpath=".//tr/td[1]") %>% rvest::html_text(),
    rls_date = rvest::html_nodes(pg, xpath=".//tr/td[2]") %>%
      rvest::html_text() %>%
      stri_extract_first_regex("[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}")
  ) %>%
    dplyr::filter(!is.na(rls_date)) %>%
    dplyr::mutate(rls_date = as.Date(rls_date)) %>%
    dplyr::mutate(rls_year = lubridate::year(rls_date)) %>%
    dplyr::mutate(
      vers = ifelse(stri_count_fixed(vers, ".") == 1, sprintf("%s.0", vers), vers)
    ) %>%
    dplyr::distinct(vers, .keep_all=TRUE) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_tibble()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels = vers)) -> out

  if (use_cache() && (refresh || (!is_cached(tech)))) write_to_cache(out, tech)

  out

}