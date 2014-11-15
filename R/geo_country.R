#'@title
#'Country-level geolocation
#'
#'@description
#'\code{geo_country} geolocates IP addresses to the country level, providing the
#'\href{https://en.wikipedia.org/wiki/ISO_3166-2}{ISO 3166-2} code for the resulting country.
#'It uses (in order) \href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database}
#'and \href{https://github.com/maxmind/GeoIP2-python}{the associated Python API}, with
#'\code{\link{rpy}} as a connector. The Python API is required for it to work.
#'
#'@param ips a vector of IP addresses
#'
#'@return a vector of country names. NULL or invalid responses from the API will be replaced with the string "Invalid".
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{geo_city}} for city-level identification, \code{\link{geo_tz}}
#'for tzdata-compatible timezone identification and \code{\link{geo_netspeed}} for connection
#'type detection.
#'@export

geo_country <- function(ips){
  
  #If it's bigger than 2m, split and recursively call
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_country))
    names(results) <- NULL
    return(results)
    
  }
  
  #Handle possible sequences of IPs due to x_forwarded_for
  ips <- xff_handler(ips)
  
  #Handle invalid IPs
  ips <- iconv(ips, to = "UTF-8")
  ips[nchar(ips) > 39] <- ""
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geo_country.py"), conduit = "text")
  
  #Mark invalid results
  results[is.na(results)] <- "Invalid"
  results[results %in% c("EU","AP","A1","A2","O1", "")] <- "Invalid"
  
  #Return
  return(results)
}