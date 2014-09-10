#'@title
#'Run a query against the WMF hive instance
#'
#'@description
#'\code{hive_query} is a simple wrapper around the command line that makes queries
#'against our Hive/Hadoop infrastructure more convenient.
#'
#'@param query a query, or the location of a .hql file containing a query.
#'
#'@param ... other arguments to pass to read.delim.
#'
#'@return a data.frame containing the results of the query.
#'
#'@export
hive_query <- function(query, to_file = FALSE, file = NULL, ...){
  
  #If the user wants it passed straight to R...
  if(!to_file){
    
    #Create temp file
    file <- tempfile(pattern = "file", fileext = ".tsv")
  
  }
  
  #Run query
  if(grepl(x = query, pattern = "\\.hql$")){
    
    system(paste("export HADOOP_HEAPSIZE=1024 && hive -f", query, ">", file))
    
  } else {
    
    #Otherwise, pipe the query to file to avoid having to deal with [expletive]
    #quoting problems, and run that
    query_file <- tempfile(fileext = ".hql")
    cat(query, file = query_file)
    system(paste("export HADOOP_HEAPSIZE=1024 && hive -f", query_file, ">", file))
    
  }
  
  #If the user wanted the data provided..
  if(!to_file){
    
    #Read in data
    data <- read.delim(file = temp_file, header = TRUE, as.is = TRUE, quote = "", ...)
    
    #Remove temp file
    file.remove(temp_file)
    
    #Return data
    return(data)
  }
  
  #Otherwise, return TRUE
  return(TRUE)
  
}