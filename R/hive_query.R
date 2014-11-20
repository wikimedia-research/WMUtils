#'@title
#'Run a query against the WMF hive instance
#'
#'@description
#'\code{hive_query} is a simple wrapper around the command line that makes queries
#'against our Hive/Hadoop infrastructure more convenient.
#'
#'@param query a query, or the location of a .hql file containing a query.
#'
#'@param db the database to use. Set to wmf_raw (which contains the webrequest table) by default.
#'
#'@param user your hive username (normally your stat100* username)
#'
#'@param dt Whether to return it as a data.table or not.
#'
#'@param heapsize the HADOOP_HEAPSIZE to use. 1024 by default.
#'
#'@return a data.frame or data.table containing the results of the query.
#'
#'@section handling our hadoop/hive setup:
#'
#'The \code{webrequests} table is documented
#'\href{https://wikitech.wikimedia.org/wiki/Analytics/Cluster/Hive}{on Wikitech}, which also provides
#'\href{https://wikitech.wikimedia.org/wiki/Analytics/Cluster/Hive/Queries}{a set of example
#'queries}.
#'
#'When it comes to manipulating the rows with Java before they get to you, Nuria has written a
#'\href{https://wikitech.wikimedia.org/wiki/Analytics/Cluster/Hive/QueryUsingUDF}{brief tutorial on loading UDFs}
#'which should help if you want to engage in that; the example provided is a user agent parser, allowing you to
#'get the equivalent of \code{\link{ua_parse}}'s output further upstream.
#'@seealso \code{\link{log_strptime}} for converting the "dt" column in the webrequests table to POSIXlt,
#'\code{\link{parse_uuids}} for parsing app unique IDs out of requestlog URLs,
#'and \code{\link{mysql_query}} and \code{\link{global_query}} for querying our MySQL databases.
#'
#'@import RJDBC
#'
#'@export
hive_query <- function(query, db = "wmf_raw", user, dt = TRUE, heapsize = 1024){
  
  #If there's no heapsize set, set.
  if(Sys.getenv("HADOOP_HEAPSIZE") != heapsize){
    Sys.setenv(HADOOP_HEAPSIZE = heapsize)
  }
  
  #If the query is a file, retrieve it
  if(grepl(x = query, pattern = "\\.hql$")){
    suppressWarnings(expr = {
      query <- paste(readLines(query), collapse = "")
    })
  }
  
  #Initialise the Java environment
  .jinit(force.init = TRUE)
  .jaddClassPath(c(list.files("/usr/lib/hadoop/", full.names = TRUE, pattern = "\\.jar$"),
                   list.files("/usr/lib/hive/lib/", full.names = TRUE, pattern = "\\.jar$"),
                   list.files("/usr/lib/hadoop/lib", full.names = TRUE, pattern = "\\.jar$")))

  #Connect
  drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/usr/lib/hive/lib/hive-jdbc.jar")
  con <- dbConnect(drv = drv, url = paste0("jdbc:hive2://analytics1027.eqiad.wmnet:10000/",db),
                    user = user)
  
  #Add JSonSerDe
  dbSendUpdate(con, "ADD JAR /usr/lib/hive-hcatalog/share/hcatalog/hive-hcatalog-core-0.12.0-cdh5.0.2.jar")
  
  #Query, retrieve, clear, close
  to_fetch <- dbSendQuery(con, query)
  data <- try({
    fetch(res = to_fetch, n = -1)
  }, silent = TRUE)
  dbClearResult(to_fetch)
  dbDisconnect(con)
  
  if("try-error" %in% class(data)){
    stop(data)
  }
  
  #Do we want this as a data table?
  if(dt){
    data <- as.data.table(data)
  }
  
  #Return
  return(data)
  
}