geo_city <- function(ips){
  
  #Handle big vectors
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_city))
    names(results) <- NULL
    return(results)
  }
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geo_city.py"))
  
  #Extract city
  cities <- unlist(lapply(results, function(x){
    
    if(is.null(x)){
      
      return("Invalid")
      
    }
    
    if(is.null(x$city)){
      
      return("Invalid")
      
    }
    
    return(x$city)
    
  }))
  
  #Return
  return(cities)
  
}