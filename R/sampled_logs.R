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
#'ip_address, status_code, url, mime_type, referer, x_forwarded, user_agent, lang and x_analytics.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso
#'\code{\link{log_strptime}} for handling the log timestamp format, \code{\link{parse_uuids}} for parsing out
#'app UUIDs from URLs, \code{\link{log_sieve}} for filtering the sampled logs to "pageviews",
#'and \code{\link{hive_query}} for querying the unsampled RequestLogs.
#'
#'@return a data.table containing the useful columns from the sampled logs of the day you asked for.
#'
#'@export
sampled_logs <- function(file){
  
  #parsers, column names
  sampled_parsers <- list(skip_parser(),skip_parser(),character_parser(),skip_parser(),
                          character_parser(),character_parser(),skip_parser(),skip_parser(),
                          character_parser(),skip_parser(), character_parser(),character_parser(),
                          character_parser(), character_parser(), character_parser(), character_parser())
  
  sampled_colnames <-   c("squid","sequence_no",
                          "timestamp", "servicetime",
                          "ip_address", "status_code",
                          "reply_size", "request_method",
                          "url", "squid_status",
                          "mime_type", "referer",
                          "x_forwarded", "user_agent",
                          "lang", "x_analytics")
  
  #Check whether a file was provided, or a date. If a data, construct a filename
  if(!grepl(x =  file, pattern = "/")){
    #Construct file address
    file <- paste("/a/squid/archive/sampled/sampled-1000.tsv.log-",file,".gz", sep = "")
  }
  
  #Create temp file
  output_file <- tempfile()
  
  #Copy and unzip
  system(paste("gunzip -c", file, ">", output_file))

  #Read in
  data <- read_delim(output_file, quote = "", delim = "\t",
                     parsers = sampled_parsers, col_names = sampled_colnames)
    
  
  #Remove temp file
  file.remove(output_file)
    
  #Return
  return(as.data.table(data))
  
}