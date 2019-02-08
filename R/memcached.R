fix_memcached_dates <- function(x) {

  x <- stri_replace_all_fixed(x, c("(", ")", "th", "rd", ","), "", vectorize_all = FALSE)

  as.Date(lubridate::parse_date_time(x, c("ymd", "mdy")))

}

#' Retrieve memcached Version Release History
#'
#' Clones the `memcached` wiki and reads `ReleaseNotes.md` to build a data frame of
#' `memcached` version release numbers and dates with semantic version
#' strings parsed and separate fields added. The data frame is also arranged in
#' order from lowest version to latest version and the `vers` column is an
#' ordered factor. It uses [git2r::cred_ssh_key()] so you *must* have SSH keys
#' setup in order for this function to work.
#'
#' @md
#' @note This is an *expensive* function as it does quite a wiki clone.
#'       Please consider using some sort of cache for the results unless
#'       absolutely necessary.
#' @export
memcached_version_history <- function() {

  td <- tempfile("wiki", fileext="git")

  dir.create(td)

  git2r::clone(
    url = "git@github.com:memcached/memcached.wiki.git",
    local_path = td,
    credentials = git2r::cred_ssh_key(),
    progress = FALSE
  ) -> repo

  on.exit(unlink(td, recursive = TRUE), add = TRUE)

  readr::read_lines(file.path(repo@path, "ReleaseNotes.md")) %>%
    purrr::keep(stri_detect_fixed, "[[ReleaseNotes") %>%
    stri_replace_first_regex(" \\* \\[\\[.*]] ", "") %>%
    stri_split_fixed(" ", 2, simplify = TRUE) %>%
    dplyr::as_tibble() %>%
    purrr::set_names(c("vers", "rls_date")) %>%
    dplyr::mutate(string = stri_trim_both(vers)) %>%
    dplyr::mutate(rls_date = fix_memcached_dates(rls_date)) %>%
    dplyr::mutate(rls_year = lubridate::year(rls_date)) %>%
    dplyr::bind_cols(
      semver::parse_version(.$vers) %>%
        dplyr::as_tibble()
    ) %>%
    dplyr::arrange(major, minor, patch) %>%
    dplyr::mutate(vers = factor(vers, levels = vers))

}

