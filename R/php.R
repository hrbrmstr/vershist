#' Retrieve PHP Version Release History
#'
#' Reads <https://secure.php.net/releases/> to build a data frame of PHP version
#' release numbers and dates with semantic version strings parsed and separate
#' fields added. The data frame is also arranged in order from lowest version
#' to latest version and the `vers` column is an ordered factor.
#'
#' @md
#' @export
php_version_history <- function() {

  php_changes_url <- "https://secure.php.net/releases/"

  doc <- suppressWarnings(xml2::read_html(php_changes_url))

  rls <- html_nodes(doc, xpath = ".//h2/following-sibling::ul")

  dplyr::tibble(
    vers = rvest::html_nodes(rls, xpath=".//preceding-sibling::h2") %>%
      rvest::html_text(trim=TRUE) %>%
      stringi::stri_replace_all_fixed("x", 0),
    ts = rvest::html_nodes(rls, xpath=".//li[contains(., 'Released:')]") %>%
      rvest::html_text(trim=TRUE) %>%
      stringi::stri_replace_first_fixed("Released: ", "") %>%
      as.Date(format = "%d %b %Y"),
    year = lubridate::year(ts)
  ) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_tibble()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels=vers)) %>%
    dplyr::rename(rls_date = ts, rls_year = year)

}