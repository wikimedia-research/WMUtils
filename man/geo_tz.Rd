\name{geo_tz}
\alias{geo_tz}
\title{
Timezone data}
\description{
Returns timezone data associated with an IP address
}
\usage{
geo_tz(ips)
}
\arguments{
  \item{ips}{
A vector of IPv4 IP addresses
}
}
\details{
\code{geo_tz} returns the timezone, in a tzdata-compliant format, associated with an IPv4 IP address. This can then be used to (for example) localise server-side timestamps. It uses (in order) \href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database} and \href{https://github.com/maxmind/GeoIP2-python}{the associated Python API}, with \code{\link{rpy}} as a connector. The Python API is required for it to work - the only other limitation is that it cannot (yet) handle IPv6 IPs, and that accuracy \href{http://www.maxmind.com/en/city_accuracy}{varies on a per-country basis.}
}
\seealso{
\code{\link{geo_city}} for city-level identification and \code{\link{geo_city}} for country-level identification; 
\code{\link{with_tz}} and \code{\link{from_tz}} in the \code{\link{lubridate}} package for ways to use tzdata
}