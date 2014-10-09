#'@title intertimes
#'
#'@description calculate inter-time periods between timestamps
#'
#'@details
#'\code{\link{intertimes}} takes a set of timestamps and generates the interval between them, in seconds,
#'having sorted the timestamps from earliest to latest.
#'
#'@param timestamps a vector of timestamps. These can be POSIXlt, POSIXct, numeric/integer (if you've
#'already converted them into seconds), or either MediaWiki or RequestLog timestamps.
#'
#'@seealso
#'\code{\link{session_count}} - take a set of intertime periods and work out how many sessions
#'they represent.
#'@export
intertimes <- function(timestamps){
  
  #Check input type. If it's a timestamp, numericise it
  if(sum(c("POSIXct","POSIXlt" %in% class(timestamps)))){
    
    timestamps <- as.numeric(timestamps)
    
  } else if("character" %in% class(timestamps)){
    
    #If there's 14 characters in the first entry, they're probably MW timestamps
    if(nchar(timestamps[1] == 14)){
      
      timestamps <- as.numeric(mw_strptime(timestamps))
    
    #19? Log timestamps!
    } else if(nchar(timestamps[1]) == 19){
      
      timestamps <- as.numeric(log_strptime(timestamps))
      
    }
    
  }
  
  #Otherwise it's numeric/integer. Presumably - or the user'll get a nasty shock that's entirely
  #their fault. So let's just go sort it already.
  return(cpp_intertimes(timestamps))
  
}