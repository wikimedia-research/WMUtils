\name{posix_to_mw}
\alias{posix_to_mw}
\title{
POSIX/MediaWiki timestamp conversion
}
\description{
Converts POSIXct or lt dates and times to MediaWiki-compatible 14-character timestamps
}
\usage{
posix_to_mw(timestamps)
}
\arguments{
  \item{timestamps}{
A vector of POSIXct or POSIXlt date/time objects you want to convert
}
}

\seealso{
\code{\link{mw_to_posix}} for converting MediaWiki timestamps into POSIX objects.
}