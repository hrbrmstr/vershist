% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bind.R
\name{isc_bind_version_history}
\alias{isc_bind_version_history}
\title{Retrieve ISC BIND Version Release History}
\usage{
isc_bind_version_history()
}
\description{
Reads \url{https://ftp.isc.org/isc/bind9/} to build a data frame of
ISC BIND version release numbers and dates. NOTE that BIND version strings
are ugly (despite their commitment to semantic versioning) so this function
returns the BIND version (\code{vers}), the release date (\code{rls_date}) and release year
(\code{rls_year})  arranged in order from lowest version to latest version and
the \code{vers} column is an ordered factor.
}
