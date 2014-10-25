#'@title multi_with_tz
#'@description localise timestamps to a range of different timezones
#'@details \code{multi_with_tz} takes a data.table of timezones and timestamps, and localises the timestamps
#'to match the newly-specified timezones.
#'
#'@param dt the data.table of timestamps and timezones (having other columns is not a problem)
#'
#'@param timestamp_col the name of the column containing timestamps
#'
#'@param timezone_col the name of the column containing tzdata-compatible timezones.
#'
#'@param handle_timestamps whether or not timestamps need to be converted into a POSIX format from something
#'else. Set to FALSE by default
#'
#'@param ts_handler if handle_timestamps is TRUE, a function used for the conversion. To handle MediaWiki
#'timestamps, for example, we'd use ts_handler = mw_strptime.
#'
#'@seealso \code{\link{geo_tz}} for extracting tzdata-compatible timezones from IP addresses,
#'\code{\link{log_strptime}} and \code{\link{mw_strptime}} for request log/MediaWiki timestamp
#'handling.
#'
#'@export
multi_with_tz <- function(dt, timestamp_col, timezone_col, handle_timestamps = FALSE, ts_handler){
  
  #Convert timestamps
  output <- do.call("rbind",lapply(unique(dt[,,timezone_col]), function(tz){
    
    #Grab appropriate subset and convert its timestamps.
    subset <- x[x[,,timezone_col] == tz,]
    
    if(handle_timestamps){
      timestamps <- with_tz(ts_handler(subset[,,timestamp_col]),tz)
    } else {
      timestamps <- with_tz(subset[,,timestamp_col], tz)
    }
    #Extract and include weekday and hour
    subset$hour <- hour(timestamps)
    subset$day <- as.character(x = wday(x = timestamps, label = TRUE))
    
    #Return
    return(subset)
  }))
  
  #Return
  return(output)
}