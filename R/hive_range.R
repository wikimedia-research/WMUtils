#'@title hive_range
#'@description year/month/day partition generation for hive
#'
#'@details \code{hive_range} generates an approximation of the smallest range of year/month/day partitions
#'needed to scan to get all of the requests between a starting and ending timestamp.
#'
#'The key word is "approximate"; it's not as efficient as writing these clauses by hand. But that's not always an
#'option, particularly with automated software.
#'
#'@param start_ts the start timestamp, as a POSIXlt or POSIXct object
#'
#'@param end_ts the end timestamp, as a POSIXlt or POSIXct object
#'
#'@return a character string capable of being pushed into a query with \code{\link{paste}} that contains
#'"WHERE year=...".
#'
#'@seealso
#'\code{\link{hive_query}} for querying hive, and \code{\link{to_log}} and \code{\link{log_strptime}} for
#'handling hive date/time objects.
#'
#'@export
hive_range <- function(start_ts, end_ts){
  
  #Stop if PEBCAK around start_ts/end_ts
  if(!start_ts < end_ts){
    
    stop("The starting timestamp you provided is not greater than the ending timestamp")
    
  }
  
  #If they're within a month of each other, construct
  if(ceiling_date(start_ts,"month") > end_ts){
    
    output <- paste("WHERE year =",year(start_ts),"AND month =",month(start_ts),"AND day BETWEEN",day(start_ts),"AND",day(end_ts), "AND dt BETWEEN",paste0("'",to_log(start_ts),"'"),"AND",paste0("'",to_log(end_ts),"'"))
    
  } else {
    
    #If they're within a year of each other, construct
    if(ceiling_date(start_ts,"year") > end_ts){
      
      output <- paste("Where year =",year(start_ts),"AND month BETWEEN",month(start_ts),"AND",month(end_ts), "AND dt BETWEEN",paste0("'",to_log(start_ts),"'"),"AND",paste0("'",to_log(end_ts),"'"))
      
    } else {
      
      output <- paste("Where year BETWEEN",year(start_ts),"AND",year(end_ts),"AND dt BETWEEN",paste0("'",to_log(start_ts),"'"),"AND",paste0("'",to_log(end_ts),"'"))
      
    }
  }
  
  return(output)
}