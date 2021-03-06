% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lighttpd.R
\name{lighttpd_version_history}
\alias{lighttpd_version_history}
\title{Retrieve lighttpd Version Release History}
\usage{
lighttpd_version_history()
}
\description{
Reads from the \code{lighttpd} releases and snapshot downloads to build a
data frame of version release numbers and dates. The caller is responsible
for extracting out the version components due to the non-standard
semantic versioning used. The \code{\link[=is_valid_semver]{is_valid_semver()}} function can be used to test the
validity of version strings.
}
