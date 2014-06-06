mysql_query <- function(query, db){
  
  #Open connection to the MySQL DB
  con <- dbConnect(drv = "MySQL",
                   host = "analytics-store.eqiad.wmnet",
                   dbname = db)
  
  #Query
  output <- dbGetQuery(con, query)
  
  #Kill connection
  dbDisconnect(con)
  
  #Return output
  return(output)
  
}