#' Retrieve nginx Version Release History
#'
#' Reads <https://raw.githubusercontent.com/nginx/nginx/master/docs/xml/nginx/changes.xml>
#' to build a data frame of nginx version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @export
nginx_version_history <- function() {

  nginx_changes_url <-
    "https://raw.githubusercontent.com/nginx/nginx/master/docs/xml/nginx/changes.xml"

  doc <- suppressWarnings(xml2::read_xml(nginx_changes_url))

  dplyr::tibble(
    vers = rvest::xml_nodes(doc, xpath="//changes") %>%
      xml2::xml_attr("ver"),
    ts = rvest::xml_nodes(doc, xpath="//changes") %>%
      xml2::xml_attr("date") %>%
      as.Date(),
    year = lubridate::year(ts)
  ) -> c1

  c(
    readr::read_lines("https://nginx.org/en/CHANGES-1.0"),
    readr::read_lines("https://nginx.org/en/CHANGES-1.2"),
    readr::read_lines("https://nginx.org/en/CHANGES-1.4"),
    readr::read_lines("https://nginx.org/en/CHANGES-1.6"),
    readr::read_lines("https://nginx.org/en/CHANGES-1.8"),
    readr::read_lines("https://nginx.org/en/CHANGES-1.10"),
    readr::read_lines("https://nginx.org/en/CHANGES-1.12"),
    readr::read_lines("https://nginx.org/en/CHANGES-1.14")
  ) -> nl

  read.csv(
    stringsAsFactors = FALSE,
    text = paste0(
      c("v,d", nl[grepl("^Changes", nl)] %>%
          gsub("Changes with nginx ", "", .) %>%
          gsub("[[:space:]]{3,}", ",", .)), collapse="\n")
  ) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(d = lubridate::dmy(d)) %>%
    dplyr::select(vers=1, ts=2) %>%
    dplyr::mutate(year = lubridate::year(ts)) -> c2

  dplyr::bind_rows(c1, c2) %>%
    dplyr::distinct() %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_tibble()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels=vers)) %>%
    dplyr::rename(rls_date = ts, rls_year = year)

}