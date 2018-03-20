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

  dplyr::data_frame(
    vers = rvest::xml_nodes(doc, xpath="//changes") %>%
      xml2::xml_attr("ver"),
    ts = rvest::xml_nodes(doc, xpath="//changes") %>%
      xml2::xml_attr("date") %>%
      as.Date(),
    year = lubridate::year(ts)
  ) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_data_frame()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels=vers)) %>%
    dplyr::rename(rls_date = ts, rls_year = year)

}