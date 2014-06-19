sampled_logs <- function(date, filtered = FALSE){
  
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
  
  #Filtering, if needed
  if(filtered){
    
    #Iconv
    for(i in seq_along(data)){
      
      #I bloody hate having to run a write-loop over a non-primitive object, but short of adding
      #Plyr as another dependency to take advantage of colwise, that's just how it's going to work.
      data[,i] <- iconv(x = data[,i], to = "UTF-8")
      
    }
    
    #Get rid of non text/html types
    data <- data[data$mime_type %in% c("text/html; charset=UTF-8",
                                       "text/html; charset=utf-8",
                                       "text/html; charset=iso-8859-1",
                                       "text/html; charset=ISO-8859-1",
                                       "text/html"),]
    
    #Identify non-SSH hits
    non_ssh <- !grepl(x = data$squid, pattern = "ssh", perl = TRUE)
    
    #Identify completed requests
    completed <- grepl(x = data$status_code, pattern = "(20(0|4|6)|304)", perl = TRUE)
    
    #Identify requests to sites we care about
    desired_sites <- grepl(x = data$URL, pattern = "(mediawiki|((commons|meta|species)\\.(m\\.)?wikimedia)|(wik(tionary|isource|ibooks|ivoyage|iversity|iquote|inews|ipedia|idata)))", perl = TRUE, ignore.case = TRUE)
    
    #Identify requests to content directories
    content_dirs <- grepl(x = data$URL, pattern = "(/\\?title=|/wiki\\?curid=|/sr-(ec|hl|el)/|/w/|/wiki/|/zh/|/zh-(tw|cn|hant|mo|hans|hk|sg)/|/sr/)", perl = TRUE, ignore.case = TRUE)
    
    #Limit to matches of all of those things.
    data <- data[non_ssh & completed & desired_sites & content_dirs,]
    
  }
  
  #Return
  return(data)
  
}