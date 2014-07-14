geo_city <- function(ips){
  
  #Handle big vectors
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_city))
    return(results)
  }
  
  #Where do we look for the file?
  city_file <- "/usr/share/GeoIP/GeoIPCity.dat"
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geoip.py"), type = "city", file = city_file)
  
  #Extract city
  cities <- unlist(lapply(results, function(x){
    
    if(is.null(x$city)){
      
      return("NA")
      
    } else {
      
      return(x$city)
    }
  }))
  
  #Return
  return(cities)
  
}