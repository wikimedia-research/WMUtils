sampled_logs <- function(date){
  
  #Construct file address
  origin_path <- paste("/a/squid/archive/sampled/sampled-1000.tsv.log-",date,".gz", sep = "")
  #Create a new, temp directory, move the file there and unzip
  dir_path <- dir_construct("sampled_log")
  destination_path <- file.path(dir_path,"dailydata.tsv")
  output_path <- file.path(dir_path,"processed_data.tsv")
  file.copy(from = origin_path, to = file.path(dir_path,"dailydata.tsv.gz"), overwrite = TRUE)
  system(paste("gunzip",file.path(dir_path,"dailydata.tsv.gz")))
  
  #Awk the hell out of it
  system(paste(paste("awk -v OUTPUTFILE='",output_path, "' -f", sep = ""), file.path(find.package("WMUtils"), "sampled_log_sanitiser.awk"), destination_path))
  
  #Read it in
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
  
  #Kill source files
  dir_remove(dir_path)
  
  #Return
  return(data)
  
}