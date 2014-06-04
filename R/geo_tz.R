geo_tz <- function(ips){
  
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
  
  #Return
  return(tzs)
}