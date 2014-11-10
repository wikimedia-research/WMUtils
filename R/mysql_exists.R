#'@title
#'Wrapper for checking the existence of a MySQL table
#'
#'@description
#'\code{mysql_exists} is a simple wrapper around RMySQL that allows a useR to check table existence in a database on
#'analytics-store.eqiad.wmnet.
#'
#'@param db a database
#'
#'@param table_name the name of the table
#'
#'@return A TRUE or FALSE confirming whether the table exists
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{mysql_query}} for reading from the same range of databases, \code{\link{mysql_write}}
#'for writing to them, or \code{\link{mysql_delete}} for removing rows that match a set of conditions.
#'
#'@export

mysql_exists <- function(db, table_name){
  
  #Create a connector
  con <- dbConnect(drv = "MySQL",
                   host = "analytics-store.eqiad.wmnet",
                   dbname = db,
                   default.file = "/etc/mysql/conf.d/analytics-research-client.cnf")
  
  #Grab the results and close off
  table_exists <- dbExistsTable(conn = con, name = table_name)
  dbDisconnect(con)
  
  #Return
  return(table_exists)
  
}