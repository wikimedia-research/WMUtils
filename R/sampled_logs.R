#'@title
#'Retrieve data from the sampled logs
#'
#'@description
#'\code{sampled_logs} reads in and parses data from the 1:1000 sampled RequestLogs
#'on stat1002.
#'
#'@param file either the full name of a sampled log file, or the year/month/day of the log file you want,
#'provided as YYYYMMDD
#'
#'@details
#'It does what it says on the tin; pass in a date (formatted as '20140601' or equivalent)
#'and it will retrieve the sampled requestlogs for that day. One caveat worth noting is that
#'the daily dumps are not truncated at precisely the stroke of midnight; for the example,
#'you can expect to see some of the logs from 20140602 and be missing some from the 1st,
#'which will be in 20140531. Slight fuzziness around date ranges may be necessary to get all the
#'traffic you want.
#'
#'It does not return all the fields from the log file, merely the most useful ones - namely timestamp,
#'ip_address, status_code, URL, mime_type, referer, x_forwarded, user_agent, lang and x_analytics.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso
#'\code{\link{log_strptime}} for handling the log timestamp format, \code{\link{parse_uuids}} for parsing out
#'app UUIDs from URLs, \code{\link{log_sieve}} for filtering the sampled logs to "pageviews",
#'and \code{\link{hive_query}} for querying the unsampled RequestLogs.
#'
#'@return a data.frame containing the sampled logs of the day you asked for.
#'
#'@export
sampled_logs <- function(file){
  
  #Note result names
  resultnames <- c("timestamp","ip_address","status_code","URL","mime_type",
                   "referer","x_forwarded","user_agent","lang","x_analytics")
  
  #Check whether a file was provided, or a date. If a data, construct a filename
  if(!grepl(x =  file, pattern = "/")){
    #Construct file address
    origin_path <- paste("/a/squid/archive/sampled/sampled-1000.tsv.log-",file,".gz", sep = "")
  } else {
    #Otherwise, use the filename provided
    origin_path <- file
  }
  
  #Create temp file
  output_file <- tempfile()
  save_file <- paste(output_file,".gz", sep = "")
  
  #Copy file to save_file and unzip
  if(!file.copy(from = origin_path, to = save_file, overwrite = TRUE)){
    
    warning("The file ", origin_path, " could not be found")
    return(NULL)
    
  }
  system(paste("gunzip", save_file))
  
  #Read in
  data <- c_sampled_logs(output_file)
  
  #Remove temp file
  file.remove(output_file)
    
  #Turn into a data.table and return
  data <- as.data.table(data)
  setnames(data, 1:ncol(data), resultnames)
  return(data)
  
}