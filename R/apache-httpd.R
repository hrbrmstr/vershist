#' Retrive Apache httpd Version Release History
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

  readr::read_lines("https://archive.apache.org/dist/httpd/") %>%
    purrr::keep(stri_detect_regex, 'apache_.*gz"') %>%
    stri_replace_first_fixed("<img src=\"/icons/compressed.gif\" alt=\"[   ]\"> ", "") %>%
    stri_match_first_regex('href="apache_([[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+)\\.tar\\.gz".*([[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2})') %>%
    dplyr::as_data_frame() %>%
    dplyr::select(-V1) %>%
    dplyr::rename(vers = V2, rls_date = V3) %>%
    dplyr::mutate(rls_date = as.Date(rls_date)) %>%
    dplyr::mutate(rls_year = lubridate::year(rls_date)) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        as_data_frame()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels = vers))

}
