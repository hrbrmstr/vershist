#' Retrieve MySQL Version Release History
#'
#' Scrapes <https://downloads.mysql.com/archives/community/> to build a data frame of
#' openresty version release numbers and dates with pesudo-semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor.
#'
#' The selector for versioning is "`Generic Linux (Architecture Independent)`" and
#' the first found date is used for the `rls_date`. File an issue or PR if
#' alternate behaviour is required.
#'
#' @md
#' @note This is an *expensive* function as it does quite a bit of scraping.
#'       Please consider using some sort of cache for the results unless
#'       absolutely necessary.
#' @export
mysql_version_history <- function() {

  pg <- xml2::read_html("https://downloads.mysql.com/archives/community/")

  rvest::html_nodes(pg, "select#version > option") %>%
    rvest::html_attr("value") -> versions

  pb <- dplyr::progress_estimated(length(versions))

  purrr::map_df(
    versions, ~{

      pb$tick()$print()

      httr::GET(
        url = "https://downloads.mysql.com/archives/community/",
        query = list(
          os = "src",
          osva = "Generic Linux (Architecture Independent)",
          tpl = "version",
          version = .x
        ),
        httr::user_agent("#rstats vershist package : https://github.com/hrbrmstr/vershist")
      ) -> res

      list(
        vers = .x,
        res = list(res)
      )

    }
  ) %>%
    mutate(
      rls_date = purrr::map_chr(res, content, as="text") %>%
        stri_extract_first_regex("[[:alpha:]]+[[:space:]]{1,4}[[:digit:]]{1,2},[[:space:]]{1,4}[[:digit:]]{4}") %>%
        lubridate::mdy()
    ) %>%
    mutate(rls_year = lubridate::year(rls_date)) %>%
    select(-res) %>%
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