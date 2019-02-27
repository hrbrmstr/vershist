#' Retrieve Apple iOS  Version Release History
#'
#' Reads <https://en.wikipedia.org/wiki/IOS_version_history"> to build a data
#' frame of Apple iOS version release numbers and dates with pseudo-semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @note This does not distinguish by device target and only pulls the first release
#'       date and excludes betas. If more granular data is needed, file an issue or PR.
#' @export
apple_ios_version_history <- function() {

  pg <- xml2::read_html("https://en.wikipedia.org/wiki/IOS_version_history")

  vers_nodes <- rvest::html_nodes(pg, xpath=".//th[contains(@id, '.') or contains(., '.')]")

  dplyr::tibble(
    vers = rvest::html_text(vers_nodes),
    rls_date = purrr::map_chr(
      vers_nodes,
      ~rvest::html_node(.x, xpath=".//following-sibling::td[3]") %>%
        rvest::html_text()
    )
  ) %>%
    dplyr::filter(!stri_detect_regex(vers, "Table|Post|Apple")) %>%
    dplyr::mutate(vers = stri_replace_all_regex(vers, "\\[.*\\]", "")) -> xdf

  dplyr::filter(xdf, !stri_detect_fixed(vers, "/")) %>%
    dplyr::mutate(
      rls_date = stri_extract_first_regex(
        rls_date, "[[:alpha:]]{2,}[[:space:]]+[[:digit:]]{1,2},[[:space:]]+[[:digit:]]{4}"
      )
    ) -> simple

  more_complex <- dplyr::filter(xdf, stri_detect_fixed(vers, "/"))

  c_v <- stri_extract_all_regex(more_complex$vers, "[[:digit:]\\.]+")
  c_d <- stri_extract_all_regex(more_complex$rls_date, "[[:alpha:]]{2,}[[:space:]]+[[:digit:]]{1,2},[[:space:]]+[[:digit:]]{4}")

  purrr::map2_df(c_v, c_d, ~{
    dplyr::tibble(
      vers = .x,
      rls_date = .y
    )
  }) -> more_complex

  dplyr::bind_rows(simple, more_complex) %>%
    dplyr::mutate(vers = stri_trim_both(vers)) %>%
    dplyr::mutate(rls_date = lubridate::mdy(rls_date)) %>%
    dplyr::filter(!stri_detect_fixed(vers, "Beta")) %>%
    dplyr::mutate(
      vers = ifelse(stri_count_fixed(vers, ".") == 1, sprintf("%s.0", vers), vers)
    ) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_tibble()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels = vers))

}