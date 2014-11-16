#'@title referer_handler
#'@description extract the host from a URL
#'@details \code{referer_handler} extracts the host from a URL and extracts general organisational
#'handles ("google", "reddit")
#'
#'@param urls a vector of URLs
#'
#'@return a vector of hostnames or organisational handles.
#'
#'@export
referer_handler <- function(urls){
  
  #Extract domain
  urls <- host_handler(urls)
  
  #Categorise
  urls[grepl(x = urls, pattern = "(wik(tionary|isource|ibooks|ivoyage|iversity|iquote|inews|ipedia|idata)\\.",
                 useBytes = TRUE, perl = TRUE)] <- "Internal"
  urls[grepl(x = urls, pattern = "google(usercontent)?.", perl = TRUE, useBytes = TRUE)] <- "Google"
  urls[grepl(x = urls, pattern = "yahoo.", fixed = TRUE)] <- "Yahoo"
  urls[grepl(x = urls, pattern = "yandex.", fixed = TRUE)] <- "Yandex"
  urls[grepl(x = urls, pattern = "baidu.", fixed = TRUE)] <- "Baidu"
  urls[grepl(x = urls, pattern = "reddit.com", fixed = TRUE)] <- "Reddit"
  urls[grepl(x = urls, pattern = "ask.com", fixed = TRUE)] <- "Ask"
  urls[grepl(x = urls, pattern = "facebook.", fixed = TRUE)] <- "Facebook"
  urls[grepl(x = urls, pattern = "aol.", fixed = TRUE)] <- "AOL"
  urls[grepl(x = urls, pattern = "naver.", fixed = TRUE)] <- "Naver"
  urls[grepl(x = urls, pattern = "duckduckgo.", fixed = TRUE)] <- "DuckDuckGo"
  urls[grepl(x = urls, pattern = "sogou.", fixed = TRUE)] <- "Sogou"
  urls[grepl(x = urls, pattern = "bing.", fixed = TRUE)] <- "Bing"
  urls[grepl(x = urls, pattern = "daum.", fixed = TRUE)] <- "Daum"
  urls[grepl(x = urls, pattern = "t.co", fixed = TRUE)] <- "Twitter"
  urls[grepl(x = urls, pattern = "twitter.", fixed = TRUE)] <- "Twitter"
  urls[grepl(x = urls, pattern = "seznam.cz", fixed = TRUE)] <- "Seznam"
  urls[grepl(x = urls, pattern = "startpage.", fixed = TRUE)] <- "Startpage"
  urls[!urls %in% c("Internal","Google","Yahoo","Yandex","Baidu","Reddit","None",
                            "Ask", "Facebook", "AOL", "Naver","DuckDuckGo","Sogou",
                            "Bing","Daum","Twitter","Seznam","Startpage")] <- "Other"
  
  #Return
  return(urls)
}