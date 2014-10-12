#'@title
#'Connection type detection
#'
#'@description
#'\code{geo_netspeed} provides connection types for the provided IP address(es)
#'It uses (in order) \href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database}
#'and \href{https://github.com/maxmind/GeoIP2-python}{the associated Python API}, with
#'\code{\link{rpy}} as a connector. The Python API is required for it to work.
#'
#'Unlike the other geo-related functions, \code{geo_netspeed} does not currently support IPv6
#'
#'@param ips a vector of IP addresses
#'
#'@return a vector of connection categories. NULL or invalid responses from the API will be replaced with
#'the string "Invalid".
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{geo_city}} for city-level identification, \code{\link{geo_tz}}
#'for tzdata-compatible timezone identification, or \code{\link{geo_country}} for country-level geolocation.
#'@export

geo_netspeed <- function(ips){
  
  #If it's bigger than 2m, split and recursively call
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_netspeed))
    names(results) <- NULL
    return(results)
    
  }
  
  #Handle invalid IPs
  ips <- iconv(ips, to = "UTF-8")
  ips[nchar(ips) > 39] <- ""
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geo_netspeed.py"), conduit = "text")
  
  #Mark invalid results
  results[is.na(results)] <- "Invalid"
  results[results == "Unknown"] <- "Invalid"
  
  #Return
  return(results)
}