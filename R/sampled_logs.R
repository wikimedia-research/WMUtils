#'@title
#'Retrieve data from the sampled logs
#'
#'@description
#'\code{sampled_logs} reads in and parses data from the 1:1000 sampled RequestLogs
#'on stat1002.
#'
#'@param date the year/month/day of the log file you want.
#'
#'@param use_fread whether to use fread. This /can/ be faster, but is inconsistently so, depending
#'on the contents of the input log file. As such, it's set to FALSE by default.
#'
#'@param dt whether to return the sampled logs as a data.table or not. Set to TRUE
#'by default.
#'
#'@details
#'It does what it says on the tin; pass in a date (formatted as '20140601' or equivalent)
#'and it will retrieve the sampled requestlogs for that day. One caveat worth noting is that
#'the daily dumps are not truncated at precisely the stroke of midnight; for the example,
#'you can expect to see some of the logs from 20140602 and be missing some from the 1st,
#'which will be in 20140531. Slight fuzziness around date ranges may be necessary to get all the
#'traffic you want.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso
#'\code{\link{log_strptime}} for handling the log timestamp format and \code{\link{hive_query}}
#'for querying the unsampled RequestLogs.
#'@return a data.frame containing the sampled logs of the day you asked for.
#'@export
sampled_logs <- function(date, use_fread = FALSE, dt = TRUE){
  
  #Construct file address
  origin_path <- paste("/a/squid/archive/sampled/sampled-1000.tsv.log-",date,".gz", sep = "")
  
  #Create temp file
  output_file <- tempfile()
  save_file <- paste(output_file,".gz", sep = "")
  
  #Copy file to save_file and unzip
  if(!file.copy(from = origin_path, to = save_file, overwrite = TRUE)){
    
    warning("The file for ", date, " could not be found")
    return(NULL)
    
  }
  system(paste("gunzip", save_file))
  
  #Read in
  if(use_fread){
  tryclass <- try(expr = {
    
    data <- fread(input = output_file, sep = "\t", showProgress = FALSE, header = FALSE,
                  colClasses = rep("character", 16))
    setnames(data, c("squid","sequence_no",
                     "timestamp", "servicetime",
                     "ip_address", "status_code",
                     "reply_size", "request_method",
                     "URL", "squid_status",
                     "mime_type", "referer",
                     "x_forwarded", "user_agent",
                     "lang", "x_analytics"))
    
  }, silent = TRUE)
  }
  if(!use_fread || class(tryclass) == "try-error"){
    
    data <- read.delim(output_file, as.is = TRUE,
                       quote = "",
                       col.names = c("squid","sequence_no",
                                     "timestamp", "servicetime",
                                     "ip_address", "status_code",
                                     "reply_size", "request_method",
                                     "URL", "squid_status",
                                     "mime_type", "referer",
                                     "x_forwarded", "user_agent",
                                     "lang", "x_analytics"))
    
  }
  
  #Remove temp file
  file.remove(output_file)
  
  #If a data.table is requested, set it
  if(dt){
    
    data <- as.data.table(data)
    return(data)
  }

  #Otherwise, data frame
  data <- as.data.frame(data)
  return(data)
  
}