#' Retrieve lighttpd Version Release History
#'
#' Reads from the `lighttpd` releases and snapshot downloads to build a
#' data frame of version release numbers and dates. The caller is responsible
#' for extracting out the version components due to the non-standard
#' semantic versioning used. The [is_valid_semver()] function can be used to test the
#' validity of version strings.
#'
#' @md
#' @export
lighttpd_version_history <- function() {

  c("https://download.lighttpd.net/lighttpd/releases-1.4.x/",
    "https://download.lighttpd.net/lighttpd/snapshots-1.5/",
    "https://download.lighttpd.net/lighttpd/snapshots-1.4.x/",
    "https://download.lighttpd.net/lighttpd/snapshots-2.0.x/"
  ) %>%
    purrr::map_df(~{
      pg <- read_html(.x)
      dplyr::tibble(
        vers = rvest::html_nodes(pg, xpath=".//tr/td[1]") %>%
          rvest::html_text(),
        ts = rvest::html_nodes(pg, xpath=".//tr/td[2]") %>%
          rvest::html_text()
      )
    }) %>%
    dplyr::filter(stri_detect_regex(vers, "\\.tar\\.gz$")) %>%
    dplyr::mutate(vers = stri_replace_all_regex(vers, "(^lighttpd-|\\.tar\\.gz$)", "")) %>%
    dplyr::mutate(
      ts = lubridate::ymd_hms(ts),
      year = lubridate::year(ts)
    ) %>%
    dplyr::rename(rls_date = ts, rls_year = year)

}