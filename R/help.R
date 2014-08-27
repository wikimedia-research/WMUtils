#'WMUtils - a WMF utilities package in R
#'
#'It slices, it dices, it handles:
#'
#'@section RequestLogs:
#'We don't study readers enough, and we finally have the tools to do that. WMUtils contains
#'several functions centred on the RequestLogs. \code{\link{hive_query}} allows you to query
#'the unsampled logs, while \code{\link{sampled_logs}} allows you to retrieve the 1:1000 sampled
#'ones. For both data types, \code{\link{log_strptime}} turns the timestamp format used into
#'POSIXlt timestamps.
#'
#'@section MySQL:
#'If you study editors, our MySQL databases are where all the data lives. \code{\link{mysql_query}}
#'allows you to query a single database on \code{analytics-store.eqiad.wmnet}, while
#'\code{\link{global_query}} allows you to run over multiple databases. Either way,
#'\code{\link{mw_strptime}} turns the timestamp format used in our DB into POSIXlt timestamps.
#'
#'@section Geodata:
#'Thanks to a nice python library, pygeoip, we have an easy API to access geographic data
#'associated with IP addresses. \code{\link{geo_country}} retrieves country codes,
#'\code{\link{geo_city}} retrieves cities, and \code{\link{geo_tz}} tzdata-compatible timezones.
#'
#'@section User agents:
#'Our user-agent parsing, which use's \href{https://code.google.com/p/pygeoip/}{tobie's ua-parser},
#'is in Python. It's also now in R thanks to \code{\link{ua_parse}}. If you run into incorrectly
#'identified user agents, poke Oliver, since he's a maintainer on the repository.
#'
#'@section Language integration:
#'both geodata retrieval and user agent parsing are dependent on Python libraries, so this
#'also contains a R-to-Python-to-R connector, \code{\link{rpy}}. This allows you to pipe
#'R objects into Python, run an arbitrary Python script over them, and pipe the results back into
#'R. It comes with two convenience functions for handling the results - \code{\link{py_df}} and
#'\code{\link{rpy_vec}}.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'@docType package
#'@name WMUtils
#'@aliases WMUtils WMUtils-package
#'@import RMySQL RJSONIO
NULL