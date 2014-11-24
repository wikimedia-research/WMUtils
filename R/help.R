#'WMUtils - a WMF utilities package in R
#'
#'It slices, it dices, it handles:
#'
#'@section RequestLogs:
#'We don't study readers enough, and we finally have the tools to do that. WMUtils contains
#'several functions centred on the RequestLogs. \code{\link{hive_query}} allows you to query
#'the unsampled logs, while \code{\link{sampled_logs}} allows you to retrieve the 1:1000 sampled
#'ones. For both data types, \code{\link{log_strptime}} turns the timestamp format used into
#'POSIXlt timestamps, while \code{\link{log_sieve}} applies a prototype pageviews filter to the
#'output of \code{sampled_logs}. \code{\link{extract_mcc}} allows you to retrieve MCC codes from zero-tagged
#'requests, while \code{\link{host_handler}} and \code{\link{project_extractor}} truncate URLs to hostnames and
#'(in the case of Wikimedia URLs) language.project pairs, respectively.
#'
#'@section MySQL:
#'If you study editors, our MySQL databases are where all the data lives. \code{\link{mysql_query}}
#'allows you to query a single database on \code{analytics-store.eqiad.wmnet}, while
#'\code{\link{global_query}} allows you to run over multiple databases. Either way,
#'\code{\link{mw_strptime}} turns the timestamp format used in our DB into POSIXlt timestamps.
#'And once you're done processing, use \code{\link{mysql_write}} to stream the results up to
#'the databases again. Need to update previously written rows? No problem! \code{\link{mysql_delete}}
#'is the function for you.
#'
#'@section Geodata:
#'Thanks to MaxMind's C API, we can access geographic data associated with IP addresses
#'\code{\link{geo_country}} retrieves country codes, \code{\link{geo_region}} region codes or names,
#'\code{\link{geo_city}} cities, and \code{\link{geo_tz}} retrieves tzdata-compatible timezones.
#'
#'@section User agents:
#'Our user-agent parsing, which uses \href{https://github.com/ua-parser/uap-cpp}{tobie's ua-parser},
#'is in C++ It's also now in R thanks to Rcpp. If you run into incorrectly
#'identified user agents, poke Oliver, since he's a maintainer on the ua-parser repositories.
#'
#'@section Session analysis:
#'For session analysis, WMUtils contains \code{\link{intertimes}}, \code{\link{session_count}},
#'\code{\link{session_length}} and \code{\link{session_pages}}, all implemented in C++ for speed
#'(improvements in some cases are up to three orders of magnitude. R handles recursion really poorly).
#'
#'@section Namespace matching:
#'\code{\link{namespace_match}} allows you convert namespace numbers to localised names, or
#'vice versa, handling the presence of namespaces in reader or editor data. The dataset is
#'also made available as \code{\link{namespace_names}}, or rebuildable via
#'\code{\link{namespace_match_generator}}.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'@docType package
#'@name WMUtils
#'@import data.table
#'@importFrom Rcpp evalCpp
#'@useDynLib WMUtils
#'@aliases WMUtils WMUtils-package
NULL