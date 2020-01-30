#' Citrix Netscaler ADC Version History
#'
#' Reads <https://support.citrix.com/article/CTX121840> to build a data frame of
#' Citrix Netscaler ADC version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @export
citrix_netscaler_version_history <- function() {

  pg <- xml2::read_html("https://support.citrix.com/article/CTX121840")

  v <- rvest::html_nodes(pg, xpath = ".//h3[contains(., 'NetScaler Software Release')]")

  purrr::map_df(v, ~{
    cols <- ifelse(grepl("11.1", html_text(.x)), 2, 1)
    tibble::tibble(
      bld = rvest::html_nodes(.x, xpath = sprintf(".//following-sibling::table[1]//td[%s]", cols)) %>% rvest::html_text(trim = TRUE),
      rls_date = rvest::html_nodes(.x, xpath = sprintf(".//following-sibling::table[1]//td[%s]", cols+1)) %>% rvest::html_text(trim = TRUE)
    ) %>%
      mutate(bld = gsub("[[:space:]]*\\(.*$", "", bld)) %>%
      mutate(mm = gsub("NetScaler Software Release ", "", html_text(.x)))
  }) %>%
    dplyr::select(mm, bld, rls_date) %>%
    dplyr::filter(!grepl("^10", mm)) %>%
    dplyr::filter(!grepl("Build", bld)) %>%
    tidyr::separate_rows(bld, sep = "/") %>%
    dplyr::mutate(bld = gsub("[[:space:]]*[[:alpha:]].*$", "", trimws(bld))) %>%
    tidyr::separate(mm, c("maj", "min"), sep="\\.") %>%
    tidyr::separate(bld, c("pat", "bld"), sep="\\.", fill = "right") %>%
    dplyr::mutate(bld = ifelse(is.na(bld), "0", bld)) %>%
    dplyr::mutate(vers = sprintf("%s.%s.%s.%s", maj, min, pat, bld)) %>%
    dplyr::mutate(rls_date = lubridate::mdy(rls_date)) %>%
    dplyr::mutate(rls_year = lubridate::year(rls_date)) %>%
    dplyr::select(vers, rls_date, rls_year, maj, min, pat, bld) %>%
    dplyr::distinct() %>%
    dplyr::arrange(rls_date) %>%
    dplyr::mutate(vers = forcats::fct_inorder(vers, ordered = TRUE))

}

