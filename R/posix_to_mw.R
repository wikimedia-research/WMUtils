posix_to_mw <- function(timestamps){
  
  #Convert
  converted_timestamps <- gsub(x =as.character(timestamps), pattern = "(-|:| )", replacement = "")
  
  #Return
  return(converted_timestamps)
  
}