#' Retrieve Apache httpd Version Release History
#'
#' Reads <https://archive.apache.org/dist/httpd/> to build a data frame of
#' Apache `httpd` version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @export
apache_httpd_version_history <- function() {

  ap <- readr::read_lines("https://archive.apache.org/dist/httpd/")

  apd <- xml2::read_html(paste0(ap[grepl('"(httpd-|apache_)[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+\\.tar', ap)], collapse="\n"))

  rvest::html_text(apd) %>%
    stri_split_lines() %>%
    unlist() %>%
    stri_match_first_regex("([[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2})") %>%
    .[,2] -> rls_dates

  rvest::html_nodes(apd, "a") %>%
    rvest::html_attr("href") %>%
    stri_match_first_regex("[-_]([[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+)\\.tar") %>%
    .[,2] -> vers

  dplyr::tibble(
    vers = vers,
    rls_date = rls_dates
  ) %>%
    dplyr::distinct(vers, .keep_all=TRUE) %>%
    mutate(rls_date = as.Date(rls_date)) %>%
    mutate(rls_year = lubridate::year(rls_date)) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_tibble()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels = vers))
}
