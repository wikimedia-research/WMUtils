geo_country <- function(ips){
  
  #If it's bigger than 2m, split and recursively call
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_country))
    names(results) <- NULL
    return(results)
  }
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geo_country.py"))
  
  #Return
  return(results)
}