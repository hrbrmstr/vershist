#' Retrieve Virtualbox Version Release History
#'
#' Reads <https://download.virtualbox.org/virtualbox/> to build a data frame of
#' Virtualbox version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @export
virtualbox_version_history <- function() {

  pg <- xml2::read_html("https://download.virtualbox.org/virtualbox/")

  rvest::html_node(pg, "pre") %>%
    rvest::html_text() %>%
    stri_split_lines() %>%
    unlist() %>%
    stri_trim_both() %>%
    keep(stri_detect_regex, "^[[:digit:]]") %>%
    discard(stri_detect_fixed, "_") %>%
    stri_match_first_regex("^([^/]+)/[[:space:]]+([[:digit:]]{2}-[[:alpha:]]{3}-[[:digit:]]{4})") %>%
    .[,2:3] %>%
    as.data.frame(stringsAsFactors=FALSE) %>%
    dplyr::as_tibble() %>%
    dplyr::select(vers = V1, rls_date = V2) %>%
    tidyr::separate(vers, into = c("major", "minor", "patch"), sep = "\\.", remove = FALSE) %>%
    dplyr::mutate(
      rls_date = lubridate::dmy(rls_date),
      rls_year = lubridate::year(rls_date)
    ) %>%
    dplyr::select(vers, rls_date, rls_year, major, minor, patch) %>%
    dplyr::arrange(as.integer(major), as.integer(minor), as.integer(patch)) %>%
    dplyr::mutate(vers = factor(vers, levels = vers))

}

