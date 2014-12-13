#'@title timestamp handling for MediaWiki
#'@description Format timestamps from our MediaWiki dbs as POSIXlt timestamps.
#'
#'@param x a vector containing full (14-character) MediaWiki timestamps
#'
#'@return a vector of POSIXlt timestamps
#'
#'@seealso \code{\link{mysql_query}} for querying a single database, \code{\link{global_query}}
#'for querying multiple databases, and code{\link{log_strptime}} for equivalent functionality
#'as applied to the RequestLogs. 
#'
#'@export
mw_strptime <- function(x){
  
  #Handle field overflows; strptime will overflow if it's too long
  x[nchar(x) > 14] <- NA
  
  #Convert and retun
  return(strptime(x, format = "%Y%m%d%H%M%S", tz = "UTC"))
  
}

#'@title timestamp handling for the RequestLogs
#'@description Format timestamps from our sampled and unsampled RequestLogs
#'as POSIXlt timestamps.
#'
#'@param x a vector containing timestamps
#'
#'@details
#'As with all timestamp conversion, unconvertible timestamps (which are to be expected: both
#'the sampled and unsampled logs sometimes get columns wrong) are stored as an NA.
#'\code{column <- column[!is.na(column)]} will exclude them.
#'
#'@return a vector of POSIXlt timestamps
#'
#'@seealso \code{\link{hive_query}} for querying the unsampled logs, \code{\link{sampled_logs}}
#'for querying the sampled logs, \code{\link{parse_uuids}} for parsing app unique IDs out of requestlog URLs,
#'and \code{\link{mw_strptime}} for parsing MediaWiki timestamps.
#'
#'@export
log_strptime <- function(x){
  
  #Handle field overflows; strptime will overflow if it's too long.
  #In addition, historical timestamps counted ms.
  x <- iconv(x, to = "UTF-8")
  x[nchar(x) > 19] <- substring(x[nchar(x) > 19],1,19)
  
  #Convert and return
  return(strptime(x, format = "%Y-%m-%dT%H:%M:%S", tz = "UTC"))
  
}

#'@title to_log
#'@description POSIX-to-log timestamp conversion
#'
#'@details
#'\code{to_mw} takes a POSIXct or POSIXlt timestamp (or a character representation of those formats)
#'and converts it into a character string that matches our RequestLogs' timestamp format, as used
#'in the sampled and unsampled logs.
#'
#'@param timestamp a vector of POSIX timestamps, represented as an object of class POSIXct, POSIXlt or
#'character.
#'
#'@return a vector of log-compatible timestamps, stored as character strings.
#'
#'@seealso
#'\code{\link{hive_query}} and \code{\link{sampled_logs}} for accessing the RequestLogs,
#'\code{\link{log_strptime}} for the same operation in reverse, and \code{\link{to_mw}} for
#'the equivalent operation for MediaWiki date/times.
#'
#'@export
to_log <- function(timestamp){
  
  return(gsub(x = timestamp, pattern = " ", replacement = "T"))
  
}

#'@title to_mw
#'@description POSIX-to-MediaWiki timestamp conversion
#'
#'@details
#'\code{to_mw} takes a POSIXct or POSIXlt timestamp (or a character representation of those formats)
#'and converts it into a character string consumable by MediaWiki - and, by extension, consumable
#'by our MySQL databases that contain MediaWiki-derived content.
#'
#'@param timestamp a vector of POSIX timestamps, represented as an object of class POSIXct, POSIXlt or
#'character.
#'
#'@return a vector of MediaWiki-compatible timestamps, stored as character strings
#'
#'@seealso
#'\code{\link{mysql_query}} and \code{\link{global_query}} for querying our MySQL databases,
#'\code{\link{mw_strptime}} for the same operation in reverse, and \code{\link{to_log}} for
#'the equivalent operation for our Hive datastore or sampled log date/times.
#'
#'@export
to_mw <- function(timestamp){
  
  return(gsub(x = timestamp, pattern = "(:| |-)", replacement = ""))
  
}