sampled_logs <- function(date, filtered = FALSE, parsed_agents = FALSE, geo_country = FALSE, collect = TRUE){
  
  #Construct file address
  origin_path <- paste("/a/squid/archive/sampled/sampled-1000.tsv.log-",date,".gz", sep = "")
  
  #Specify directory/path variables
  dir_path <- dir_construct("sampled_log")
  destination_path <- file.path(dir_path,"dailydata.tsv")
  output_path <- file.path(dir_path,"processed_data.tsv")
  
  #Move file to the temp directory, unzip
  if(!file.copy(from = origin_path, to = file.path(dir_path,"dailydata.tsv.gz"), overwrite = TRUE)){
    
    stop("The file for ", date, " could not be found")
    return(NULL)
    
  }
  interned <- system(paste("gunzip",file.path(dir_path,"dailydata.tsv.gz")))
  
  #Awk the hell out of it, suppressing warnings (any problems can be handled more usefully by the tryCatch below)
  suppressWarnings(expr = {
    
    system(paste(paste("awk -v OUTPUTFILE='",output_path, "' -f", sep = ""), file.path(find.package("WMUtils"), "sampled_log_sanitiser.awk"), destination_path), intern = TRUE)
  
  })
  
  #Read it in
  tryCatch(expr = {
    data <- read.delim(file = output_path, sep = "\t", header = FALSE,
                        as.is = TRUE, quote = "",
                        col.names = c("squid","sequence_no",
                                      "timestamp", "servicetime",
                                      "ip_address", "status_code",
                                      "reply_size", "request_method",
                                      "URL", "squid_status",
                                      "mime_type", "referer",
                                      "x_forwarded", "user_agent",
                                      "lang", "x_analytics"))
  }, warning = function(e){
    
    #Stop, with error
    stop(paste("The file for", date, "could not be read in. See ?sampled_logs for potential causes"))
    
    #Delete directory
    dir_remove(dir_path)
    
    #Return null
    return(NULL)}
  )
  
  #If it didn't error out...still remove the directory and its contents. We don't need it any more and it's a space-hog
  dir_remove(dir_path)
  
  #Filtering, if needed
  if(filtered){
    
    data <- pv_filter(data = data)
    
  }
  
  #UA parsing, if needed
  if(parsed_agents){
    
    data <- cbind(data, ua_parse(user_agents = data$user_agent))
    
  }
  
  #Geolocation, if needed
  if(geo_country){
    
    #Pass through x_forwardeds
    data$ip_address[!data$x_forwarded == "-"] <- data$x_forwarded[!data$x_forwarded == "-"]
    
    #Geolocate
    data$country <- geo_country(ips = data$ip_address)
    
  }
  
  #Explicit garbage collection?
  if(collect){
    
    gc(verbose = FALSE)
    
  }
  
  #Return
  return(data)
  
}