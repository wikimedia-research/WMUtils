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
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{mysql_query}} for querying an individual db
#'@export

global_query <- function(query, project_type = "all"){
  
  #Construct the query
  if(!project_type == "all"){
    
    info_query <- paste("SELECT wiki FROM wiki_info WHERE code =",project_type)
    
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
      
    }
    
    #Increment the progress bar
    setTxtProgressBar(get("progress",envir = env),(progress$getVal()+1))
    
    #Return
    return(data)
    
  }, query = query)
  cat("\n")
  
  #Bind it into a single df
  data <- do.call(what = "rbind", args = data)
  
  #Return
  return(data)
}