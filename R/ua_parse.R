#' @title ua_parse
#' @description user agent parsing
#' @details
#' \code{ua_parse} is the R/C++ implementation of
#' \href{https://github.com/ua-parser/uap-cpp}{tobie's ua-parser}, consuming a vector of user agents
#' and returning a data frame, with each field (see 'arguments') as a distinct column.
#' 
#' @param user_agents A vector of unparsed user agents
#' 
#' @author Oliver Keyes <okeyes@@wikimedia.org>
#' 
#' @return a data.frame containing the results of the UA parsing - the device, the operating system,
#' the browser, and the browser's major and minor version numbers.
#' 
#' @export
ua_parse <- function(user_agents){
  
  #Grab YAML file
  yaml_file <- file.path(find.package("WMUtils"),"regexes.yaml")
  
  #Run
  parsed_agents <- c_ua_parse(user_agents, yaml_file)
  
  #Return
  return(parsed_agents)
  
}