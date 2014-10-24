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