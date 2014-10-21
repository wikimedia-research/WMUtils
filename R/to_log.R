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