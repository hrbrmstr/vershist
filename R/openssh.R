#' Retrieve OpenSSH (non-portable) Version Release History
#'
#' Reads <https://www.openssh.com/releasenotes.html> to build a data frame of
#' OpenSSH (non-portable) version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @note File an issue or PR if the "portable" equivalent is needed
#' @export
openssh_version_history <- function() {

  pg <- xml2::read_html("https://www.openssh.com/releasenotes.html")

  dplyr::data_frame(

    vers = rvest::html_nodes(
      pg, xpath=".//h3/a[contains(@href, 'release') and not(contains(@name, 'p'))]"
    ) %>%
      rvest::html_attr("name"),

    rls_date = rvest::html_nodes(
      pg, xpath=".//h3/a[contains(@href, 'release') and not(contains(@name, 'p'))]/.."
    ) %>%
      rvest::html_text() %>%
      stri_extract_first_regex("[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}")

  ) %>%
    dplyr::filter(!is.na(rls_date)) %>% # 3.8.1p1 is portable only and we grab non-p
    dplyr::mutate(rls_date = as.Date(rls_date)) %>%
    dplyr::mutate(rls_year = lubridate::year(rls_date)) %>%
    dplyr::mutate(
      vers = ifelse(stri_count_fixed(vers, ".") == 1, sprintf("%s.0", vers), vers)
    ) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_data_frame()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels = vers))

}

