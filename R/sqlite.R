#' Retrieve SQLite Version Release History
#'
#' Scrapes <https://sqlite.org/changes.html> to build a data frame of
#' openresty version release numbers and dates with pesudo-semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @export
sqlite_version_history <- function() {

  xml2::read_html("https://sqlite.org/changes.html") %>%
    rvest::html_nodes(xpath=".//h3[contains(., '(')]") %>%
    rvest::html_text() %>%
    purrr::discard(stri_detect_fixed, "Not") %>%
    stri_trans_tolower() %>%
    stri_replace_all_fixed(c("(", ")"), "", vectorize_all = FALSE) %>%
    stri_replace_all_fixed("-a", " a") %>%
    stri_split_fixed(" ", 2) %>%
    purrr::map_df(~as.list(.x) %>% purrr::set_names(c("rls_date", "vers"))) %>%
    tidyr::separate(vers, c("vers2", "prerelease"), sep=" ", fill="right", remove=FALSE) %>%
    dplyr::mutate(prerelease = ifelse(is.na(prerelease), "", prerelease)) %>%
    tidyr::separate(vers2, c("major", "minor", "patch", "build"), sep="\\.", fill="right") %>%
    dplyr::mutate(build = ifelse(is.na(build), "", build)) %>%
    dplyr::mutate(patch = ifelse(is.na(patch), 0, patch)) %>%
    dplyr::mutate_at(.vars=c("major", "minor", "patch"), .fun=c(as.integer)) %>%
    dplyr::mutate(rls_date = as.Date(rls_date)) %>%
    dplyr::mutate(rls_year = lubridate::year(rls_date)) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels=vers)) %>%
    dplyr::select(vers, rls_date, rls_year, major, minor, patch, prerelease, build)

}
