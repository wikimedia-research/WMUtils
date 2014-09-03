#'@title
#'query wrapper for analytics-store.eqiad.wmnet
#'
#'@description
#'\code{mysql_query} is a simple wrapper around RMySQL that allows a useR to query the dbs on
#'analytics-store.eqiad.wmnet
#'
#'@param query the SQL query you want to run
#'
#'@param db the db name you want to run the query against
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{global_query}} for querying all "production" databases in
#'analytics-store.eqiad.wmnet with a common query, \code{\link{mw_strptime}} for converting
#'MediaWiki timestamps into POSIXlt timestamps.
#'
#'@export

mysql_query <- function(query, db){
  
  #Open connection to the MySQL DB
  con <- dbConnect(drv = "MySQL",
                   host = "analytics-store.eqiad.wmnet",
                   dbname = db)
  
  #Query
  to_fetch <- dbSendQuery(con, query)
  
  #Retrieve data
  data <- fetch(to_fetch, -1)
  
  #End and disconnect
  dbClearResult(dbListResults(con)[[1]])
  dbDisconnect(con)
  
  #Return output
  return(data)
  
}