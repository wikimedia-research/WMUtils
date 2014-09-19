#'@title
#'Wrapper for removing rows from a MySQL table, on the matching of some conditional
#'
#'@description
#'\code{mysql_delete} is a simple wrapper around RMySQL that allows a useR to remove records from a table in
#'one of the analytics-store.eqiad.wmnet databases.
#'
#'@param db a database
#'
#'@param table the name of the table
#'
#'@param conditional a conditional statement (beginning 'WHERE...') for the row deletion. NULL by
#'default, which deletes the entire contents of the table.
#'
#'@return A TRUE (or an error)
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{mysql_query}} for reading from the same range of databases, \code{\link{mysql_write}}
#'for writing to them, or \code\link{mysql_exists} for checking the existence of a table.
#'
#'@export
mysql_delete <- function(db, table, conditional = NULL){
  
  #Create connection
  con <- dbConnect(drv = "MySQL",
                   host = "analytics-store.eqiad.wmnet",
                   dbname = db)
  
  #Send query
  result <- dbSendQuery(con, paste("delete FROM", table, conditional))
  
  #Close connection, return true
  dbDisconnect(con)
  return(TRUE)
  
}