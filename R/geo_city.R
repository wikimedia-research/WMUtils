geo_city <- function(ips){
  
  #Where do we look for the file?
  city_file <- "/usr/share/GeoIP/GeoIPCity.dat"
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geoip.py"), type = "city", file = city_file)
  
  #Extract city
  cities <- lapply(results, function(x){
    
    if(is.null(x$city)){
      
      return("NA")
      
    } else {
      
      return(x$city)
    }
  })
  
  #Return
  return(cities)
  
}