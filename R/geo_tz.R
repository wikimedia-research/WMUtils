#'@title
#'tzdata-compatible timezone retrieval
#'
#'@description
#'\code{geo_tz} returns the timezone, in a tzdata-compliant format, associated with an IPv4 IP
#'address. This can then be used to (for example) localise server-side timestamps. It uses
#'(in order) \href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database} and
#'\href{https://github.com/maxmind/GeoIP2-python}{the associated Python API}, with
#'\code{\link{rpy}} as a connector. The Python API is required for it to work - the only other
#'limitation is that accuracy
#'\href{http://www.maxmind.com/en/city_accuracy}{varies on a per-country basis}.
#'NULL or non-country responses from the API will be replaced with the string "Invalid".
#'
#'@param ips a vector of IP addresses
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{geo_city}} for city-level identification and \code{\link{geo_country}}
#'for country-level identification.
#'
#'@export

geo_tz <- function(ips){
  
  #Handle big vectors
  if(length(ips) > 2000000){
    
    ips <- split(ips, ceiling(seq_along(ips)/2000000))
    results <- unlist(lapply(ips, geo_tz))
    return(results)
  }
  
  #Call rpy
  results <- rpy(x = ips, script = file.path(find.package("WMUtils"),"geo_tz.py"))
  
  #Mark invalid entriees
  results[is.na(results)] <- "Invalid"
  
  #Return
  return(results)
}