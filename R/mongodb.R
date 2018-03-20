#' Retrieve MongoDB Version Release History
#'
#' Reads <https://www.mongodb.org/dl/linux"> to build a data frame of
#' MongoDB version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @note Release candidates are not included and release history is only
#'       supported for linux releases.
#' @export
mongodb_version_history <- function() {

  pg <- xml2::read_html("https://www.mongodb.org/dl/linux")

  dplyr::data_frame(
    vers = rvest::html_nodes(pg, xpath=".//tr/td[1]") %>%
      rvest::html_text(),
    ts = rvest::html_nodes(pg, xpath=".//tr/td[2]") %>%
      rvest::html_text()
  ) %>%
    dplyr::filter(
      !stri_detect_regex(vers, "(ubuntu|rhel|suse|debian|amazon|debug|latest)")
    ) %>%
    dplyr::mutate(
      vers = stri_extract_first_regex(
        vers,
        "[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]"
      ),
      ts = stri_sub(ts, 1, 10)
    ) %>%
    dplyr::distinct(vers, .keep_all=TRUE) %>%
    dplyr::filter(!is.na(vers)) %>%
    dplyr::mutate(year = lubridate::year(ts)) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_data_frame()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels=vers)) %>%
    dplyr::rename(rls_date = ts, rls_year = year)

}
