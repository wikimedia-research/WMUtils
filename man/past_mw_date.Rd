\name{past_mw_date}
\alias{past_mw_date}
\title{
MediaWiki date incrementing or decrementing}
\description{
Generates a previous date in a mediawiki-compatible format

}
\usage{
past_mw_date(date = NULL, offset, full_timestamp = TRUE)
}
\arguments{
  \item{date}{
  The date, which can be provided as a POSIX/Date object, as a 8-character MediaWiki date, or not at all. If it is not provided (the default), the function will rely on the current date, as determined by \code{\link{Sys.Date}}.
  }
  \item{offset}{
  The number of days you want to increment or decrement.
  }
  \item{full_timestamp}{
  Are you looking for an 8-character date, for use with functions like LEFT(), or a full timestamp that can just be plugged into your SQL query? 
  }
}