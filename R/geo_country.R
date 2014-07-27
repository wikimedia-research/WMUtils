geo_country <- function(ips){
  
  #If it's bigger than 2m, split and recursively call
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_country))
    names(results) <- NULL
    return(results)
  }
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geoip.py"), type = "country", file = "/usr/share/GeoIP/GeoIP.dat", ipv6 = "/usr/share/GeoIP//GeoIPv6.dat")
  
  #Return
  return(results)
}