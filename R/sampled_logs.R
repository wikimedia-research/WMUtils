sampled_logs <- function(date, filtered = FALSE){
  
  #Set out MIMEs
  web_mimes <- c("text/html; charset=UTF-8",
    "text/html; charset=utf-8",
    "text/html; charset=iso-8859-1",
    "text/html; charset=ISO-8859-1",
    "text/html")
  
  api_mimes <- c(
    "application/vnd.php.serialized; charset=utf-8",
    "application/vnd.php.serialized; charset=UTF-8",
    "application/vnd.php.serialized; charset=iso-8859-1",
    "application/vnd.php.serialized; charset=ISO-8859-1",
    "application/vnd.php.serialized",
    "application/json; charset=utf-8",
    "application/json; charset=UTF-8",
    "application/json; charset=iso-8859-1",
    "application/json; charset=ISO-8859-1",
    "application/json",
    "text/xml; charset=utf-8",
    "text/xml; charset=UTF-8",
    "text/xml; charset=iso-8859-1",
    "text/xml; charset=ISO-8859-1",
    "text/xml",
    "application/xml; charset=UTF-8",
    "application/xml; charset=utf-8",
    "application/xml; charset=iso-8859-1",
    "application/xml; charset=ISO-8859-1",
    "application/xml",
    "application/yaml; charset=utf-8",
    "application/yaml; charset=UTF-8",
    "application/yaml; charset=iso-8859-1",
    "application/yaml; charset=ISO-8859-1",
    "application/yaml")
  
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
    data <- colwise(iconv)(df = data, to = "UTF-8")
    
    #Filter MIME types
    data <- data[data$mime_type %in% c(api_mimes,web_mimes),]
    
    #Identify non-SSH hits
    non_ssh <- !grepl(x = data$squid, pattern = "ssh", perl = TRUE)
    
    #Identify completed requests
    completed <- grepl(x = data$status_code, pattern = "(20(0|6)|304)", perl = TRUE)
    
    #Identify requests to sites we care about
    desired_sites <- grepl(x = data$URL, pattern = "((commons|meta|species)\\.(m\\.)?wikimedia\\.)|(wik(tionary|isource|ibooks|ivoyage|iversity|iquote|inews|ipedia|idata)\\.)", perl = TRUE, ignore.case = TRUE)
    
    #Identify requests to content directories
    content_dirs <- grepl(x = data$URL, pattern = "(/zh(-(tw|cn|hant|mo|hans|hk|sg))?/|/sr(-(ec|hl|el))?/|/wiki(/|\\?curid=)|/w/|/\\?title=)", perl = TRUE, ignore.case = TRUE)
    
    #Identify API requests
    api_requests <- !grepl(x = data$URL, pattern = "api\\.php")
    
    #Identify requests to apps
    app_requests <- grepl(x = data$user_agent, pattern = "(WikipediaMobile|iWiki|WikiEgg|Quickipedia(?!( bot))|Wikipanion|WiktionaryMobile|^Articles|Wikiweb|WikipediaApp|Wikiamo|WikiLinks|WikiNodes|WikiBuddy|WikiView)", perl = TRUE)
    app_parse_requests <- grepl(x = data$URL, pattern = "action=(parse|mobileview)")
    
    #Limit to matches of all of those things.
    data <- data[non_ssh & completed & desired_sites & content_dirs & ((data$mime_type %in% web_mimes & api_requests) | (data$mime_type %in% api_mimes & app_requests & app_parse_requests)),]
    
  }
  
  #Return
  return(data)
  
}