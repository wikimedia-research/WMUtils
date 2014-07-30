\name{geo_country}
\alias{geo_country}
\title{
  IP address geolocation
}
\description{
Geolocates IP addresses down to the country level
}
\usage{
geo_country(ips)
}
\arguments{
  \item{ips}{
A vector of IP addresses
}
}
\details{
\code{geo_country} geolocates IP addresses to the country level, providing the \href{https://en.wikipedia.org/wiki/ISO_3166-2}{ISO 3166-2} code for the resulting country. It uses (in order) \href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database} and \href{https://github.com/maxmind/GeoIP2-python}{the associated Python API}, with \code{\link{rpy}} as a connector. The Python API is required for it to work. NULL or non-country responses from the API will be replaced with the string "Invalid".
}
\seealso{
\code{\link{geo_city}} for city-level identification and \code{\link{geo_tz}} for tzdata-compatible timezone identification}