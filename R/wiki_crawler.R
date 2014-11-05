#'@title wiki_crawler
#'@description identifies Wikimedia-specific crawlers from their user agents
#'
#'@details \code{\link{ua_parse}} is great for identifying spiders, but only /generic/ spiders - for
#'obvious reasons. Unfortunately there are some Wikimedia-specific spiders out there which need to be
#'caught. \code{wiki_crawler} hopes to identify these.
#'
#'@param agents a vector of user agents
#'@return a logical vector indicating whether or not a user agent was identified as a MediaWiki-specific
#'spider.
#'
#'@seealso \code{\link{hive_query}} and \code{\link{sampled_logs}} for extracting request logs,
#'\code{\link{ua_parse}} for generic user-agent identification.
#'
#'@export
wiki_crawler <- function(agents){
  
  #Iconv agents
  agents <- iconv(agents, to = "UTF-8")
  
  #Check for Wikimedia-specific spiders
  is_spider <- grepl(x = agents, pattern = "(wikiwix-bot|goo wikipedia|MediaWikiCrawler-Google)",
                     perl = TRUE, useBytes = TRUE)
  
  #Return
  return(is_spider)
}