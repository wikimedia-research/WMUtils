geo_tz <- function(ips){
  
  #Handle big vectors
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_tz))
    return(results)
  }
  
  #Where do we look for the file?
  city_file <- "/usr/share/GeoIP/GeoIPCity.dat"
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geoip.py"), type = "tz", file = city_file)
  
  #Handle NULLs
  tzs <- unlist(lapply(results, function(x){
    
    if(is.null(x)){
      
      return("")
      
    } else {
      
      return(x)
    }
    
  }))
  
  #Remove names
  names(tzs) <- NULL
  
  #Return
  return(tzs)
}