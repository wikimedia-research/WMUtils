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
#'for querying the sampled logs, and \code{\link{mw_strptime}} for parsing MediaWiki timestamps.
#'@export
log_strptime <- function(x){
  
  #Handle field overflows; strptime will overflow if it's too long
  x <- iconv(x, to = "UTF-8")
  x[nchar(x) > 19] <- NA
  
  #Convert and return
  return(strptime(x, format = "%Y-%m-%dT%H:%M:%S", tz = "UTC"))
  
}