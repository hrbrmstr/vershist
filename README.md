
# vershist

Collect Version Histories For Vendor Products

## Description

Provides a set of functions to gather version histories of products
(mainly software products) from their sources (generally websites).

## What’s Inside The Tin

The following functions are implemented:

Core:

  - `apache_httpd_version_history`: Retrive Apache httpd Version Release
    History
  - `lighttpd_version_history`: Retrive lighttpd Version Release History
  - `mongodb_version_history`: Retrive MongoDB Version Release History
  - `nginx_version_history`: Retrive nginx Version Release History
  - `sendmail_version_history`: Retrive sendmail Version Release History

Utility:

  - `is_valid`: Test if semantic version strings are valid

## Installation

``` r
devtools::install_github("hrbrmstr/vershist")
```

## Usage

``` r
library(vershist)

# current verison
packageVersion("vershist")
```

    ## [1] '0.1.0'

Apache

``` r
apache_httpd_version_history()
```

    ## # A tibble: 29 x 8
    ##    vers   rls_date   rls_year major minor patch prerelease build
    ##    <fct>  <date>        <dbl> <int> <int> <int> <chr>      <chr>
    ##  1 1.3.0  1998-06-05     1998     1     3     0 ""         ""   
    ##  2 1.3.1  1998-07-22     1998     1     3     1 ""         ""   
    ##  3 1.3.2  1998-09-21     1998     1     3     2 ""         ""   
    ##  4 1.3.3  1998-10-09     1998     1     3     3 ""         ""   
    ##  5 1.3.4  1999-01-10     1999     1     3     4 ""         ""   
    ##  6 1.3.6  1999-03-23     1999     1     3     6 ""         ""   
    ##  7 1.3.9  1999-08-19     1999     1     3     9 ""         ""   
    ##  8 1.3.11 2000-01-22     2000     1     3    11 ""         ""   
    ##  9 1.3.12 2000-02-25     2000     1     3    12 ""         ""   
    ## 10 1.3.14 2000-10-10     2000     1     3    14 ""         ""   
    ## # ... with 19 more rows

lighttpd

``` r
lighttpd_version_history()
```

    ## # A tibble: 97 x 3
    ##    vers         rls_date            rls_year
    ##    <chr>        <dttm>                 <dbl>
    ##  1 1.4.20       2008-09-29 23:27:45     2008
    ##  2 1.4.21-r2389 2009-02-05 12:43:18     2009
    ##  3 1.4.13       2007-01-29 00:07:24     2007
    ##  4 1.4.41       2016-07-31 12:51:39     2016
    ##  5 1.4.27       2010-08-13 09:32:03     2010
    ##  6 1.4.46       2017-10-21 19:54:46     2017
    ##  7 1.4.39       2016-01-02 12:57:37     2016
    ##  8 1.4.40       2016-07-16 10:28:52     2016
    ##  9 1.4.32       2012-11-21 09:26:14     2012
    ## 10 1.4.30       2011-12-18 15:23:06     2011
    ## # ... with 87 more rows

mongodb

``` r
mongodb_version_history()
```

    ## # A tibble: 194 x 8
    ##    vers  rls_date   rls_year major minor patch prerelease build
    ##    <fct> <chr>         <dbl> <int> <int> <int> <chr>      <chr>
    ##  1 0.8.0 2009-02-11     2009     0     8     0 ""         ""   
    ##  2 0.9.0 2009-03-27     2009     0     9     0 ""         ""   
    ##  3 0.9.1 2009-08-24     2009     0     9     1 ""         ""   
    ##  4 0.9.2 2009-05-22     2009     0     9     2 ""         ""   
    ##  5 0.9.3 2009-05-29     2009     0     9     3 ""         ""   
    ##  6 0.9.4 2009-06-09     2009     0     9     4 ""         ""   
    ##  7 0.9.5 2009-06-23     2009     0     9     5 ""         ""   
    ##  8 0.9.6 2009-07-08     2009     0     9     6 ""         ""   
    ##  9 0.9.7 2009-07-29     2009     0     9     7 ""         ""   
    ## 10 0.9.8 2009-08-14     2009     0     9     8 ""         ""   
    ## # ... with 184 more rows

nginx

``` r
nginx_version_history()
```

    ## # A tibble: 423 x 8
    ##    vers  rls_date   rls_year major minor patch prerelease build
    ##    <fct> <date>        <dbl> <int> <int> <int> <chr>      <chr>
    ##  1 0.1.0 2004-10-04     2004     0     1     0 ""         ""   
    ##  2 0.1.1 2004-10-11     2004     0     1     1 ""         ""   
    ##  3 0.1.2 2004-10-21     2004     0     1     2 ""         ""   
    ##  4 0.1.3 2004-10-25     2004     0     1     3 ""         ""   
    ##  5 0.1.4 2004-10-26     2004     0     1     4 ""         ""   
    ##  6 0.1.5 2004-11-11     2004     0     1     5 ""         ""   
    ##  7 0.1.6 2004-11-11     2004     0     1     6 ""         ""   
    ##  8 0.1.7 2004-11-12     2004     0     1     7 ""         ""   
    ##  9 0.1.8 2004-11-20     2004     0     1     8 ""         ""   
    ## 10 0.1.9 2004-11-25     2004     0     1     9 ""         ""   
    ## # ... with 413 more rows

sendmail

``` r
sendmail_version_history()
```

    ## # A tibble: 16 x 8
    ##    vers    rls_date   rls_year major minor patch prerelease build
    ##    <fct>   <date>        <dbl> <int> <int> <int> <chr>      <chr>
    ##  1 8.12.11 2004-01-18     2004     8    12    11 ""         ""   
    ##  2 8.13.6  2006-03-22     2006     8    13     6 ""         ""   
    ##  3 8.13.7  2006-06-05     2006     8    13     7 ""         ""   
    ##  4 8.13.8  2006-08-09     2006     8    13     8 ""         ""   
    ##  5 8.14.0  2007-02-01     2007     8    14     0 ""         ""   
    ##  6 8.14.1  2007-04-04     2007     8    14     1 ""         ""   
    ##  7 8.14.2  2007-11-01     2007     8    14     2 ""         ""   
    ##  8 8.14.3  2008-05-03     2008     8    14     3 ""         ""   
    ##  9 8.14.4  2009-12-29     2009     8    14     4 ""         ""   
    ## 10 8.14.5  2011-05-17     2011     8    14     5 ""         ""   
    ## 11 8.14.6  2012-12-23     2012     8    14     6 ""         ""   
    ## 12 8.14.7  2013-04-21     2013     8    14     7 ""         ""   
    ## 13 8.14.8  2014-01-26     2014     8    14     8 ""         ""   
    ## 14 8.14.9  2014-05-21     2014     8    14     9 ""         ""   
    ## 15 8.15.1  2014-12-06     2014     8    15     1 ""         ""   
    ## 16 8.15.2  2015-07-03     2015     8    15     2 ""         ""
