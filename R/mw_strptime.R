#'@title timestamp handling for MediaWiki
#'@description Format timestamps from our MediaWiki dbs as POSIXlt timestamps.
#'
#'@param x a vector containing timestamps
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
  x[nchar(x) > 30] <- NA
  
  #Convert and retun
  return(strptime(x, format = "%Y%m%d%H%M%S", tz = "UTC"))
  
}