mw_to_posix <- function(timestamps){
  
  #Convert
  converted_timestamps <- strptime(x = timestamps, format = "%Y%m%d%H%M%S")
  
  #Return
  return(converted_timestamps)
  
}