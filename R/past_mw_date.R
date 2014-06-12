past_mw_date <- function(date = NULL, offset, full_timestamp = TRUE){
  
  if(is.null(date)){
    
    #If the date hasn't been provided, assume system time
    date <- Sys.Date()
    
  }
  
  #Convert input. We'll assume it's a MW timestamp if it's of character class
  if(class(date) == "character"){
    
    date <- as.Date(date, format = "%Y%m%d")
    
  }
  
  #Add the offset
  date <- date + offset
  
  #Convert into a mw-compatible timestamp
  date <- gsub(x = as.character(date), pattern = "-", replacement = "")
  
  #Do we need a full timestamp?
  if(full_time){
    
    date <- paste(date, "000000", sep = "")
    
  }
  
  return(date)
}