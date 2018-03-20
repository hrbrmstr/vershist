#' Collect Version Histories For Vendor Products
#'
#' Provides a set of functions to gather version histories of products
#' (mainly software products) from their sources (generally websites).
#'
#' @md
#' @name vershist
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import semver
#' @importFrom purrr keep discard map map_df %>%
#' @importFrom dplyr mutate rename select as_data_frame left_join bind_cols arrange
#' @importFrom dplyr rename
#' @importFrom stringi stri_match_first_regex stri_detect_fixed stri_detect_regex
#' @importFrom stringi stri_replace_all_regex stri_replace_first_fixed
#' @importFrom stringi stri_extract_first_regex stri_sub
#' @importFrom lubridate year mdy mdy_hms
#' @importFrom readr read_lines
#' @importFrom utils globalVariables
#' @importFrom xml2 read_html read_xml xml_attr
#' @importFrom rvest html_nodes html_text xml_nodes
#' @importFrom curl curl
#' @useDynLib vershist
#' @importFrom Rcpp sourceCpp
NULL