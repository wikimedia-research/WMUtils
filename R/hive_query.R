#'@title
#'Run a query against the WMF hive instance
#'
#'@description
#'\code{hive_query} is a simple wrapper around the command line that makes queries
#'against our Hive/Hadoop infrastructure more convenient.
#'
#'@param query a .hql file containing a valid query
#'
#'@param ... other arguments to pass to read.delim
#'
#'@return a data.frame containing the results of the query.
#'
#'@export
hive_query <- function(query, ...){
  
  #Create temp file
  temp_file <- tempfile(pattern = "file", fileext = ".tsv")
  
  #Run query
  system(paste("export HADOOP_HEAPSIZE=1024 && hive -f", query, ">", temp_file))
  
  #Read in data
  data <- read.delim(file = temp_file, header = TRUE, as.is = TRUE, quote = "", ...)
  
  #Remove temp directory
  suppressWarnings(expr = {
    try(expr = {file.remove(temp_file)},
        silent = TRUE)
  })
  
  #Return data
  return(data)
}