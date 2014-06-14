geo_country <- function(ips){
  
  #If it's bigger than 2m, split and recursively call
  if(length(user_agents) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_country))
    return(results)
  }
  
  #Where do we look for the file?
  country_file <- "/usr/share/GeoIP/GeoIP.dat"
  
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geoip.py"), type = "country", file = country_file)
  
  #Return
  return(results)
}