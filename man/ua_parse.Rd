\name{ua_parse}
\alias{ua_parse}
\title{
User agent parsing
}
\description{
A connector to Tobie's ua-parser library, specifically the python port
}
\usage{
ua_parse(user_agents, fields = c("device", "os", "browser", "browser_major", "browser_minor"))
}
\arguments{
  \item{user_agents}{
A vector of unparsed user agents}
  \item{fields}{
The elements you'd like to return. Options are "device" (the device code, when known), "os" (the operating system, when known), "browser" (the browser), "browser_major" (the major version of the browser) and browser_minor (the minor version of the browser)}
}
\details{
ua_parse acts as a connector to \href{https://github.com/tobie/ua-parser}{tobie's ua-parser}, consuming a vector of user agents and returning a data frame, with each field (see 'arguments') as a distinct column. This can be usefully parsed by \code{\link{rpy_df}} or \code{\link{rpy_vec}} to handle the NULL entries that result from R's interpretation of Python's 'None' type, and turn it into a more useful object than an endlessly long list.
}
\value{
The function returns a data frame, with each field as a distinct column.
}

\seealso{
\code{\link{rpy_df}} or \code{\link{rpy_vec}} to rework the resulting object; \code{\link{rpy}} for the syntactic sugar this is built on.}
