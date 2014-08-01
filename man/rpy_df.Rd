\name{rpy_df}
\alias{rpy_df}
\title{convert JSONified python lists into data.frames.}
\usage{
rpy_df(list, stringsAsFactors = FALSE, ...)
}
\arguments{
  \item{list}{the list you want converted into a
  data.frame.}

  \item{stringsAsFactors}{whether you want character
  columns to be converted into factors. This is set as
  false by default because factors have almost never been
  the right answer to a problem.}

  \item{...}{any further parameters you want to push
  through to data.frame.}
}
\description{
\code{rpy_df} turns the R lists representing Python lists
passed through JSON into R data.frames, handling NULL
values along the way.
}
\author{
Oliver Keyes <okeyes@wikimedia.org>
}

