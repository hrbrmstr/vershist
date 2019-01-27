#' Retrieve ISC BIND Version Release History
#'
#' Reads <https://ftp.isc.org/isc/bind9/> to build a data frame of
#' ISC BIND version release numbers and dates. NOTE that BIND version strings
#' are ugly (despite their commitment to semantic versioning) so this function
#' returns the BIND version (`vers`), the release date (`rls_date`) and release year
#' (`rls_year`)  arranged in order from lowest version to latest version and
#' the `vers` column is an ordered factor.
#'
#' @md
#' @export
isc_bind_version_history <- function() {

  bind_dir <- xml2::read_html("https://ftp.isc.org/isc/bind9/")

  rvest::html_nodes(bind_dir, xpath = ".//tr[contains(., '9.')]") %>%
    map_df(
      ~data.frame(
        vers = rvest::html_nodes(.x, xpath = ".//td[2]") %>% rvest::html_text(trim=TRUE),
        rls_date = rvest::html_nodes(.x, xpath = ".//td[3]") %>% rvest::html_text(trim=TRUE),
        stringsAsFactors = FALSE
      )
    ) %>%
    mutate(
      vers = stringi::stri_replace_last_fixed(vers, "/", ""),
      rls_date = as.Date(substr(rls_date, 1, 10))
    ) %>%
    arrange(rls_date) %>%
    mutate(vers = factor(vers)) %>%
    mutate(rls_year = lubridate::year(rls_date)) -> bind_versions

  class(bind_versions) <- c("tbl_df", "tbl", "data.frame")

  bind_versions

}