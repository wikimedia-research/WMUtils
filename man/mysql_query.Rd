\name{mysql_query}
\alias{mysql_query}
\title{
MySQL query wrapper}
\description{
A read-only wrapper for querying our internal MySQL dbs}
\usage{
mysql_query(query, db)
}
\arguments{
  \item{query}{
  The SQL statement you want to execute
}
  \item{db}{
  The database you want to run it over
  }
}
\details{
mysql_query assumes two things; first, that you have a valid \code{.cnf} file containing both your username and password, and second, that the db you intend to query is in \code{analytics-store.eqiad.wmnet} - which gives you all of the production databases, plus the EventLogging data.}
\value{
This returns a data frame.
}

\seealso{

\code{\link{global_query}} for querying all of the production dbs at once (or any subset thereof)

}