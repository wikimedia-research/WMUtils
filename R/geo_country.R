geo_country <- function(ips){
  
  #Where do we look for the file?
  country_file <- "/usr/share/GeoIP/GeoIP.dat"
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geoip.py"), type = "country", file = country_file)
  
  #Return
  return(results)
}