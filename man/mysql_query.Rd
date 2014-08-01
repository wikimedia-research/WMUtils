\name{mysql_query}
\alias{mysql_query}
\title{query wrapper for analytics-store.eqiad.wmnet}
\usage{
mysql_query(query, db)
}
\arguments{
  \item{query}{the SQL query you want to run}

  \item{db}{the db name you want to run the query against}
}
\description{
\code{mysql_query} is a simple wrapper around RMySQL that
allows a useR to query the dbs on
analytics-store.eqiad.wmnet
}
\author{
Oliver Keyes <okeyes@wikimedia.org>
}
\seealso{
\code{\link{global_query}} for querying all "production"
databases in analytics-store with a common query.
}

