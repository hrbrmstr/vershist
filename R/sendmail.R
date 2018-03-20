#' Retrieve sendmail Version Release History
#'
#' Reads <ftp://ftp.sendmail.org/pub/sendmail/"> to build a data frame of
#' `sendmail` version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' @md
#' @export
sendmail_version_history <- function() {

  con <- curl::curl("ftp://ftp.sendmail.org/pub/sendmail/")
  res <- readLines(con)
  close(con)

  stri_match_first_regex(res, "([[:alpha:]]{3} [[:digit:]]{2}  [[:digit:]]{4}) (.*)") %>%
    dplyr::as_data_frame() %>%
    dplyr::select(-V1) %>%
    dplyr::rename(vers = V3, ts = V2) %>%
    dplyr::select(vers, ts) %>%
    dplyr::filter(stri_detect_regex(vers, "^sendmail.*\\.tar\\.gz$")) %>%
    dplyr::filter(!stri_detect_fixed(vers, "->")) %>%
    dplyr::mutate(vers = stri_replace_all_regex(vers, "(^sendmail\\.|\\.tar\\.gz$)", "")) %>%
    dplyr::mutate(ts = stri_replace_all_regex(ts, "\ +", " ")) %>%
    dplyr::mutate(ts = lubridate::mdy(ts)) %>%
    dplyr::mutate(year = lubridate::year(ts)) %>%
    dplyr::rename(rls_date = ts, rls_year = year) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_data_frame()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels=vers))

}
