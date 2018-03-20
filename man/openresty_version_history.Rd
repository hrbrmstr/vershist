% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/openresty.R
\name{openresty_version_history}
\alias{openresty_version_history}
\title{Retrieve openresty Version Release History}
\usage{
openresty_version_history()
}
\description{
Reads \url{https://github.com/openresty/openresty/releases} to build a data frame of
openresty version release numbers and dates with pesudo-semantic version
strings parsed and separate fields added. The data frame is also arranged in
order from lowest version to latest version and the \code{vers} column is an
ordered factor.
}
\note{
This function requires a valid GitHub API key stored in \code{GITHUB_PAT}
}