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
#'for writing to them, or \code{\link{mysql_exists}} for checking the existence of a table.
#'
#'@importMethodsFrom RMySQL dbConnect dbSendQuery dbDisconnect
#'@export
mysql_delete <- function(db, table, conditional = NULL){
  
  #Create connection
  con <- dbConnect(drv = "MySQL",
                   host = "analytics-store.eqiad.wmnet",
                   dbname = db,
                   default.file = "/etc/mysql/conf.d/analytics-research-client.cnf")
  
  #Send query
  result <- dbSendQuery(con, paste("delete FROM", table, conditional))
  
  #Close connection, return true
  dbDisconnect(con)
  return(TRUE)
  
}

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
#'@importMethodsFrom RMySQL dbConnect dbExistsTable dbDisconnect
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

#'@title
#'Wrapper for querying the R&D MySQL instances
#'
#'@description
#'\code{mysql_query} is a simple wrapper around RMySQL that allows a useR to query the dbs on
#'analytics-store.eqiad.wmnet.
#'
#'@param query the SQL query you want to run.
#'
#'@param db the name of the database you want to run the query against.
#'
#'@param dt whether to return the results as a data.table. TRUE by default.
#'
#'@return A data.frame or data.table containing the results of the query.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{global_query}} for querying multiple "production" databases in
#'analytics-store.eqiad.wmnet with a common query, \code{\link{mw_strptime}} for converting
#'MediaWiki timestamps into POSIXlt timestamps, \code{\link{mysql_delete}} for removing rows
#'from a table that match a set of conditions, \code{\link{mysql_exists}} for checking the existence
#'of a table, or \code{\link{mysql_write}} for writing to a table.
#'
#'@importMethodsFrom RMySQL dbConnect dbSendQuery dbDisconnect dbListResults dbClearResult fetch
#'@export

mysql_query <- function(query, db, dt = TRUE){
  
  #Open connection to the MySQL DB
  con <- dbConnect(drv = "MySQL",
                   host = "analytics-store.eqiad.wmnet",
                   dbname = db,
                   default.file = "/etc/mysql/conf.d/analytics-research-client.cnf")
  
  #Query
  to_fetch <- dbSendQuery(con, query)
  
  #Retrieve data
  data <- fetch(to_fetch, -1)
  
  #End and disconnect
  dbClearResult(dbListResults(con)[[1]])
  dbDisconnect(con)
  
  #Return as a data.table, if applicable.
  if(dt){
    
    data <- as.data.table(data)
    return(data)
    
  }
  #Return output
  return(data)
  
}

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
#'@seealso \code{\link{mysql_query}} for reading from the same range of databases, \code{\link{mysql_delete}}
#'for removing rows from a table that match a set of conditions, or \code{\link{mysql_exists}}
#'for checking the existence of a table.
#'
#'@importMethodsFrom RMySQL dbConnect dbWriteTable dbDisconnect
#'@export

mysql_write <- function(x, db, table_name, ...){
  
  #Open a connection to the db
  con <- dbConnect(drv = "MySQL",
                   host = "analytics-store.eqiad.wmnet",
                   dbname = db,
                   default.file = "/etc/mysql/conf.d/analytics-research-client.cnf")
  
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