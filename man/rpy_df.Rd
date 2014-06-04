\name{rpy_df}
\alias{rpy_df}
\title{
List to Data Frame conversion
}
\description{
Converts lists created from rpy into data frames.
}
\usage{
rpy_df(list, stringsAsFactors = FALSE, ...)
}
\arguments{
  \item{list}{
    The \code{\link{rpy}}-outputted list you want converted
  }
  \item{stringsAsFactors}{
    Whether character columns should be converted to factors (TRUE) or left alone (FALSE). Defaults to FALSE.}
  \item{\dots}{
    Further arguments to \code{\link{data.frame}}
  }
}

\seealso{
\code{\link{rpy_vec}} for conversion of rpy results into vectors, and \code{\link{rpy}} itself.
}