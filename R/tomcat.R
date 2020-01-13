#' Retrieve Apache Tomcat Version Release History
#'
#' Scrapes <https://tomcat.apache.org/oldnews-2010.html> to build a data frame of
#' openresty version release numbers and dates with pesudo-semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @note alpha, beta and RCs are excluded. File an issue if these are needed.
#' @export
tomcat_version_history <- function() {

  xml2::read_html("https://tomcat.apache.org/oldnews-2010.html") %>%
    rvest::html_nodes("a[href*='oldnews']") %>%
    rvest::html_attr("href") %>%
    sprintf("https://tomcat.apache.org/%s", .) %>%
    purrr::map(read_html) %>%
    purrr::map_df(~{
      pg <- .x
      rls <- rvest::html_nodes(pg, "h3[id*='Tomcat'][id*='Released']:not([id*='Conn']):not([id*='Native']):not([id*='Maven']):not([id*='alpha']):not([id*='beta'])")
      dplyr::tibble(
        vers = rvest::html_attr(rls, "id") %>%
          stri_replace_all_regex("^Tomcat_|_Released$", ""),
        rls_date = as.Date(rvest::html_nodes(rls, "span") %>%
                             rvest::html_text()),
        rls_year = lubridate::year(rls_date)
      )
    }) %>%
    tidyr::separate(vers, c("major", "minor", "patch"), remove=FALSE) %>%
    dplyr::mutate(build = ifelse(
      stri_detect_regex(patch, "[[:alpha:]]"),
      stri_extract_first_regex(patch, "[[:alpha:]]+[[:alnum:]]*"),
      ""
    )) %>%
    dplyr::mutate(patch = stri_replace_first_regex(patch, "[[:alpha:]]+[[:alnum:]]*", "")) %>%
    dplyr::mutate_at(.vars=c("major", "minor", "patch"), .funs=c(as.integer)) %>%
    dplyr::mutate(prerelease = "") %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels=vers)) %>%
    dplyr::select(vers, rls_date, rls_year, major, minor, patch, prerelease, build)

}