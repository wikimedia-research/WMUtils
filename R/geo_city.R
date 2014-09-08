#'@title
#'City-level geolocation
#'
#'@description
#'\code{geo_city} geolocates IPv4 and IPv6 addresses to provide city-level results, providing
#'the English-language name for that city. It uses (in order)
#'\href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database} and
#'\href{https://github.com/maxmind/GeoIP2-python}{the associated Python API}, with
#'\code{\link{rpy}} as a connector. The Python API is required for it to work - the only other
#'limitation is that accuracy
#'\href{http://www.maxmind.com/en/city_accuracy}{varies on a per-country basis}.
#'
#'
#'@param ips a vector of IP addresses
#'
#'@return a vector of city names. NULL or invalid responses from the API will be replaced with the string "Invalid".
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{geo_country}} for country-level identification and \code{\link{geo_tz}}
#'for tzdata-compatible timezone identification.
#'@export

geo_city <- function(ips){
  
  #Handle big vectors
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_city))
    names(results) <- NULL
    return(results)
  }
  
  #Handle invalid IPs
  ips[nchar(ips) > 39] <- ""
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geo_city.py"))
  
  #Handle invalid results
  results[is.na(results)] <- "Invalid"
  results[results == ""] <- "Invalid"
  
  #Return
  return(results)
  
}