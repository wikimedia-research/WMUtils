pv_filter <- function(data){
  
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
  
  #Iconv
  data <- colwise(iconv)(df = data, to = "UTF-8")
  
  #Limit
  data <- data[complete.cases(data),]
  
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