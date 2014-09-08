#'@title
#'Wrapper for writing to the R&D MySQL instances
#'
#'@description
#'\code{mysql_write} is a simple wrapper around RMySQL that allows a useR to write to the dbs on
#'analytics-store.eqiad.wmnet.
#'
#'@param x a data.frame to insert into the table
#'
#'@param db the name of the database you want to write to. This is usually going to be "staging"
#'
#'@param table_name the name you want given to the resulting table.
#'
#'@param ... further arguments to pass to dbWriteTable. See ?dbWriteTable for more details.
#'
#'@return A TRUE or FALSE confirming whether the write succeeded.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{mysql_query}} for reading from the same range of databases.
#'
#'@export

mysql_write <- function(x, db, table_name, ...){
  
  #Open a connection to the db
  con <- dbConnect(drv = "MySQL",
                   host = "analytics-store.eqiad.wmnet",
                   dbname = db)
  
  #Write
  result <- dbWriteTable(conn = con,
                         name = table_name,
                         value = x,
                         row.names = FALSE,
                         ...)
  
  #Close connection
  dbDisconnect(con)
  
  #Return the success/failure
  return(result)
  
}