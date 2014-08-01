\name{global_query}
\alias{global_query}
\title{global SQL queries for analytics-store.eqiad.wmnet}
\usage{
global_query(query, project_type = "all")
}
\arguments{
  \item{query}{the SQL query you want to run}

  \item{project_type}{what class of wiki (wikisource,
  wiktionary..) you want to run against. Set to "all" by
  default.}
}
\description{
\code{global_query} is a simple wrapper around RMySQL that
allows a useR to send a query to all production dbs on
analytics-store.eqiad.wmnet, joining the results from each
query into a single object.
}
\author{
Oliver Keyes <okeyes@wikimedia.org>
}
\seealso{
\code{\link{mysql_query}} for querying an individual db
}

