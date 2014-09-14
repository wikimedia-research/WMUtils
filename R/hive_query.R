#'@title
#'Run a query against the WMF hive instance
#'
#'@description
#'\code{hive_query} is a simple wrapper around the command line that makes queries
#'against our Hive/Hadoop infrastructure more convenient.
#'
#'@param query a query, or the location of a .hql file containing a query.
#'
#'@param file a file name. If this is provided, the results of the query will be written straight
#'there, and a boolean TRUE returned. If not provided (it's NULL by default), the results of the query
#'will be returned as a data.frame
#'@param ... other arguments to pass to read.delim.
#'
#'@return a data.frame containing the results of the query, or a boolean TRUE if the user has chosen
#'to write straight to file.
#'
#'@export
hive_query <- function(query, file = NULL, ...){
  
  #If the user wants it passed straight to R...
  if(is.null(file)){
    
    #Create temp file
    file <- tempfile(pattern = "file", fileext = ".tsv")
    
    #Note
    to_R <- TRUE
  
  }
  
  #Run query. If the query is /not/ a file, make it one
  if(!grepl(x = query, pattern = "\\.hql$")){
    
    query_file <- tempfile(fileext = ".hql")
    cat(query, file = query_file)
    query <- query_file
  }
  
  #Run
  system(paste("export HADOOP_HEAPSIZE=1024 && hive -f", query, ">", file))
  
  #If the user wanted the data provided..
  if(to_R){
    
    #Read in data
    data <- read.delim(file = file, header = TRUE, as.is = TRUE, quote = "", ...)
    
    #Remove the file
    file.remove(file)
    
    #Return data
    return(data)
  }
  
  #Otherwise, return TRUE
  return(TRUE)
  
}