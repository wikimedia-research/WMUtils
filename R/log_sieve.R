#'@title log_sieve
#'
#'@description Prototype pageviews filter for the Wikimedia request logs
#'
#'@details
#'\code{log_sieve} contains the prototype filter for "pageviews", as applicable to the Wikimedia request logs.
#'It consumes logs, tags the "actual" pageviews, and returns them. While it's there, the XFFs are also
#'passed through to the ip_address field, replacing those IPs. It's implemented in R, so the full definition
#'can be seen just by printing \code{log_sieve}.
#'
#'\code{log_data}, the first argument
#'@param log_data an input data.frame or data.table. This should ideally be the output of \code{\link{sampled_logs}}
#'or \code{\link{hive_query}}, since some of \code{log_sieve}'s arguments are name-specific rather than
#'indices-specific.
#'
#'@return a data.table containing those rows of \code{log_data} that are pageviews.
#'
#'@seealso code{\link{sampled_logs}}, to read from the sampled logs, or \code{\link{hive_query}} to read from
#'the HDFS-based logs.
#'
#'@export

log_sieve <- function(log_data){
  
  #Handler for app requests, which look unusual
  app_handler <- function(x){
    
    #Is it an app request? Is it a pageview from the app?
    is_app <- grepl(x = x$user_agent, pattern = "WikipediaApp", fixed = TRUE, useBytes = TRUE)
    is_pv <- grepl(x = x$URL, pattern = "sections=0", fixed = TRUE, useBytes = TRUE)
    x <- x[is_app & is_pv,]
    
    #Return
    return(x)
  }
  
  #Is it a data.table? Make one if not
  if(!"data.table" %in% class(log_data)){
    
    log_data <- as.data.table(log_data)
    
  }
  
  #MIME level filtering
  log_data <- log_data[log_data$mime_type %in% c("text/html; charset=iso-8859-1",
                                     "text/html; charset=ISO-8859-1",
                                     "text/html",
                                     "text/html; charset=utf-8",
                                     "text/html; charset=UTF-8",
                                     "application/json; charset=utf-8"),]
  
  #Limit to 'production' sites
  log_data <- log_data[grepl(x = log_data$URL, pattern = "((commons|meta|species)\\.((m|mobile|wap|zero)\\.)?wikimedia\\.)|?<=wwww)\\.(wik(tionary|isource|ibooks|ivoyage|iversity|iquote|inews|ipedia|idata)\\.)",
                     perl = TRUE, useBytes = TRUE),]
  
  #Exclude non-app API hits.
  is_api <- grepl(x = log_data$URL, pattern = "api.php", fixed = TRUE, useBytes = TRUE)
  log_data <- rbind(log_data[!is_api,], app_handler(log_data[is_api,]))
  
  #Limit to content directories
  log_data <- log_data[grepl(x = log_data$URL, pattern = "(/zh(-(tw|cn|hant|mo|my|hans|hk|sg))?/|/sr(-(ec|el))?/|/wiki(/|\\?(cur|old)id=)|/w/|/\\?title=)",
                     useBytes = TRUE, perl = TRUE),]
  
  #Limit to successful requests
  log_data <- log_data[grepl(x = log_data$status_code, pattern = "200", useBytes = TRUE, fixed = TRUE),]
  
  #Exclude internal requests
  log_data <- log_data[!grepl(x = log_data$user_agent, pattern = "^MediaWiki/1\\.", useBytes = TRUE, perl = TRUE)]
  
  #Exclude special pages and searches
  log_data <- log_data[!grepl(x = log_data$URL, pattern = "Special:", useBytes = TRUE, fixed = TRUE),]
  log_data <- log_data[!grepl(x = log_data$URL, pattern = "index.php?search", useBytes = TRUE, fixed = TRUE),]
  
  #Normalise timestamps and eliminate entries with invalid ones
  pos_stamps <- log_strptime(log_data$timestamp)
  log_data <- log_data[!is.na(pos_stamps),]
  
  #Throw back into log_data
  log_data$timestamp <- as.character(pos_stamps[!is.na(pos_stamps)])
  
  #Handle XFFs
  is_xff_null <- log_data$x_forwarded == "-"
  log_data$ip_address[!is_xff_null] <- log_data$x_forwarded[!is_xff_null]
  
  #Return
  return(log_data)
  
}