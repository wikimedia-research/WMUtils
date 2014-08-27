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
#'NULL or non-country responses from the API will be replaced with the string "Invalid".
#'
#'@param ips a vector of IP addresses
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
  
  #Handle invalids
  cities[cities == ""] <- "Invalid"
  
  #Return
  return(cities)
  
}