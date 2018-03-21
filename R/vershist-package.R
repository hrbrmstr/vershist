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
#' @importFrom purrr keep discard map map_df %>% safely set_names
#' @importFrom dplyr mutate rename select as_data_frame left_join bind_cols arrange
#' @importFrom dplyr rename progress_estimated mutate_at distinct
#' @importFrom stringi stri_match_first_regex stri_detect_fixed stri_detect_regex
#' @importFrom stringi stri_replace_all_regex stri_replace_first_fixed stri_trans_tolower
#' @importFrom stringi stri_extract_first_regex stri_sub stri_replace_first_regex
#' @importFrom stringi stri_replace_all_fixed stri_split_fixed stri_count_fixed stri_trim_both
#' @importFrom lubridate year mdy mdy_hms parse_date_time
#' @importFrom readr read_lines
#' @importFrom utils globalVariables
#' @importFrom xml2 read_html read_xml xml_attr
#' @importFrom rvest html_nodes html_text xml_nodes
#' @importFrom curl curl
#' @importFrom gh gh gh_next
#' @importFrom tidyr separate
#' @importFrom httr content GET user_agent
#' @importFrom git2r clone cred_ssh_key
#' @useDynLib vershist
#' @importFrom Rcpp sourceCpp
NULL