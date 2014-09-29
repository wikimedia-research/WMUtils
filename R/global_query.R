#'@title
#'global SQL queries for analytics-store.eqiad.wmnet
#'
#'@description
#'\code{global_query} is a simple wrapper around RMySQL that allows a useR to send a query to all production
#'dbs on analytics-store.eqiad.wmnet, joining the results from each query into a single object.
#'
#'@param query the SQL query you want to run
#'
#'@param project_type what class of wiki (wikisource, wiktionary..) you want to run against. Set to "all" by default.
#'
#'@param dt whether to return the results as a data.table or not
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{mysql_query}} for querying an individual db, \code{\link{mw_strptime}}
#'for converting MediaWiki timestamps into POSIXlt timestamps.
#'@export

global_query <- function(query, project_type = "all", dt = TRUE){
  
  #Construct the query
  if(!project_type == "all"){
    
    info_query <- paste("SELECT wiki FROM wiki_info WHERE code = '",project_type,"'", sep = "")
    
  } else {
    
    info_query <- "SELECT wiki FROM wiki_info"
    
  }
  
  #Run query
  wikis <- mysql_query(query = info_query, db = "staging")$wiki
  
  #Instantiate progress bar and note environment
  env <- environment()
  progress <- txtProgressBar(min = 0, max = (length(wikis)), initial = 0, style = 3)
  
  #Retrieve data
  data <- lapply(wikis, function(x, query){
    
    #Retrieve the data
    data <- mysql_query(query = query, db = x)
    
    if(nrow(data) > 0){
      
      #Add the wiki
      data$project <- x
      
    } else {
      
      data <- NULL
      
    }
    
    #Increment the progress bar
    setTxtProgressBar(get("progress",envir = env),(progress$getVal()+1))
    
    #Return
    return(data)
    
  }, query = query)
  cat("\n")
  
  #Bind it into a single object
  data <- do.call(what = "rbind", args = data)
  
  #Return as a data.table, if requested. Luckily mysql_query's default settings makes this
  #a lot easier. We don't actually have to do anything.
  if(!dt){
    
    data <- as.data.frame(data)
  }
  
  #Return
  return(data)
}