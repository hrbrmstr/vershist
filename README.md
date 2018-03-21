
# vershist

Collect Version Histories For Vendor Products

## Description

Provides a set of functions to gather version histories of products
(mainly software products) from their sources (generally websites).

## What’s Inside The Tin

The following functions are implemented:

Core:

  - `apache_httpd_version_history`: Retrieve Apache httpd Version
    Release History
  - `lighttpd_version_history`: Retrieve lighttpd Version Release
    History
  - `memcached_version_history`: Retrieve memcached Version Release
    History
  - `mongodb_version_history`: Retrieve MongoDB Version Release History
  - `mysql_version_history`: Retrieve MySQL Version Release History
  - `nginx_version_history`: Retrieve nginx Version Release History
  - `openresty_version_history`: Retrieve openresty Version Release
    History
  - `openssh_version_history`: Retrieve OpenSSH Version Release History
  - `sendmail_version_history`: Retrieve sendmail Version Release
    History
  - `sqlite_version_history`: Retrieve sqlite Version Release History

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

memcached

``` r
memcached_version_history()
```

    ## # A tibble: 49 x 9
    ##    vers  rls_date   string rls_year major minor patch prerelease build
    ##    <fct> <date>     <chr>     <dbl> <int> <int> <int> <chr>      <chr>
    ##  1 1.2.7 2009-04-03 1.2.7     2009.     1     2     7 ""         ""   
    ##  2 1.2.8 2009-04-11 1.2.8     2009.     1     2     8 ""         ""   
    ##  3 1.4.0 2009-07-09 1.4.0     2009.     1     4     0 ""         ""   
    ##  4 1.4.1 2009-08-29 1.4.1     2009.     1     4     1 ""         ""   
    ##  5 1.4.2 2009-10-11 1.4.2     2009.     1     4     2 ""         ""   
    ##  6 1.4.3 2009-11-07 1.4.3     2009.     1     4     3 ""         ""   
    ##  7 1.4.4 2009-11-26 1.4.4     2009.     1     4     4 ""         ""   
    ##  8 1.4.5 2010-04-03 1.4.5     2010.     1     4     5 ""         ""   
    ##  9 1.4.6 2011-07-15 1.4.6     2011.     1     4     6 ""         ""   
    ## 10 1.4.7 2011-08-16 1.4.7     2011.     1     4     7 ""         ""   
    ## # ... with 39 more rows

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

MySQL

``` r
mysql_version_history()
```

    ## # A tibble: 201 x 8
    ##    vers    rls_date   rls_year major minor patch prerelease build
    ##    <fct>   <date>        <dbl> <int> <int> <int> <chr>      <chr>
    ##  1 5.0.15a 2005-10-25     2005     5     0    15 ""         a    
    ##  2 5.0.15  2005-10-24     2005     5     0    15 ""         ""   
    ##  3 5.0.16a 2005-11-19     2005     5     0    16 ""         a    
    ##  4 5.0.16  2005-11-18     2005     5     0    16 ""         ""   
    ##  5 5.0.17a 2005-12-16     2005     5     0    17 ""         a    
    ##  6 5.0.17  2005-12-20     2005     5     0    17 ""         ""   
    ##  7 5.0.18  2005-12-29     2005     5     0    18 ""         ""   
    ##  8 5.0.19  2006-03-07     2006     5     0    19 ""         ""   
    ##  9 5.0.20a 2006-04-20     2006     5     0    20 ""         a    
    ## 10 5.0.20  2006-04-10     2006     5     0    20 ""         ""   
    ## # ... with 191 more rows

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

openresty

``` r
openresty_version_history()
```

    ## # A tibble: 153 x 8
    ##    vers     rls_date   rls_year major minor patch prerelease build
    ##    <fct>    <date>        <dbl> <int> <int> <int> <chr>      <int>
    ##  1 0.8.54.9 2011-07-08     2011     0     8    54 ""             9
    ##  2 0.8.54.8 2011-07-01     2011     0     8    54 ""             8
    ##  3 0.8.54.6 2011-06-15     2011     0     8    54 ""             6
    ##  4 0.8.54.5 2011-05-25     2011     0     8    54 ""             5
    ##  5 0.8.54.4 2011-05-13     2011     0     8    54 ""             4
    ##  6 0.8.54.3 2011-03-29     2011     0     8    54 ""             3
    ##  7 1.0.4.2  2011-08-09     2011     1     0     4 ""             2
    ##  8 1.0.4.1  2011-07-30     2011     1     0     4 ""             1
    ##  9 1.0.4.0  2011-07-12     2011     1     0     4 ""             0
    ## 10 1.0.5.1  2011-09-04     2011     1     0     5 ""             1
    ## # ... with 143 more rows

OpenSSH

``` r
openssh_version_history()
```

    ## # A tibble: 54 x 8
    ##    vers  rls_date   rls_year major minor patch prerelease build
    ##    <fct> <date>        <dbl> <int> <int> <int> <chr>      <chr>
    ##  1 2.9.0 2001-04-29    2001.     2     9     0 ""         ""   
    ##  2 2.9.9 2001-09-25    2001.     2     9     9 ""         ""   
    ##  3 3.0.0 2001-11-06    2001.     3     0     0 ""         ""   
    ##  4 3.0.1 2001-11-19    2001.     3     0     1 ""         ""   
    ##  5 3.0.2 2002-12-04    2002.     3     0     2 ""         ""   
    ##  6 3.1.0 2004-04-09    2004.     3     1     0 ""         ""   
    ##  7 3.2.2 2002-05-16    2002.     3     2     2 ""         ""   
    ##  8 3.2.3 2002-05-23    2002.     3     2     3 ""         ""   
    ##  9 3.3.0 2002-06-21    2002.     3     3     0 ""         ""   
    ## 10 3.4.0 2002-06-26    2002.     3     4     0 ""         ""   
    ## # ... with 44 more rows

SQLite

``` r
sqlite_version_history()
```

    ## # A tibble: 285 x 8
    ##    vers   rls_date   rls_year major minor patch prerelease build
    ##    <fct>  <date>        <dbl> <int> <int> <int> <chr>      <chr>
    ##  1 1.0    2000-08-17    2000.     1     0     0 ""         ""   
    ##  2 1.0.1  2000-08-18    2000.     1     0     1 ""         ""   
    ##  3 1.0.3  2000-08-22    2000.     1     0     3 ""         ""   
    ##  4 1.0.4  2000-08-28    2000.     1     0     4 ""         ""   
    ##  5 1.0.5  2000-09-14    2000.     1     0     5 ""         ""   
    ##  6 1.0.8  2000-09-30    2000.     1     0     8 ""         ""   
    ##  7 1.0.9  2000-10-09    2000.     1     0     9 ""         ""   
    ##  8 1.0.10 2000-10-11    2000.     1     0    10 ""         ""   
    ##  9 1.0.12 2000-10-17    2000.     1     0    12 ""         ""   
    ## 10 1.0.13 2000-10-19    2000.     1     0    13 ""         ""   
    ## # ... with 275 more rows

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
