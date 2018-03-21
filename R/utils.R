#' Turn partial "valid" semantic version strings into a complete semver-tri or quad strings
#'
#' For MAJOR.MINOR.PATCH (semver-tri), turn `1` into `1.0.0`; `1.1` into `1.1.0`; `1.1.1`
#' into `1.1.1`. For MAJOR.MINOR.PATCH.EXTENSION (semver-quad), turn `1` into `1.0.0.0`;
#' `1.1` into `1.1.0.0`; `1.1.1.0` into `1.1.1.0`.
#'
#' Partial validity checking is performed to test if the input strings contain only
#' digits and periods. "Invalid" input is returned unscathed.
#'
#' @param x a character vector of full or partial version strings
#' @param quad (logical) if `TRUE` then a three-dot semver is returned, else a two-dot semver
#'        is returned. Default: `FALSE`.
#' @export
complete_semver <- function(x, quad = FALSE) {

  x <- stri_trim_both(x)
  x <- stri_replace_all_regex(x, "(^\\.|\\.$)", "")

  max_dots <- if (quad) 3 else 2

  purrr::map_chr(x, ~{
    if (stri_detect_regex(.x, "^[[:digit:]\\.]+$")) {
      times <- max_dots - stri_count_fixed(.x, ".")
      if (times > 0) {
        sprintf("%s%s", .x, paste0(rep(".0", times), collapse=""))
      } else {
        .x
      }
    } else {
      .x
    }
  })

}
