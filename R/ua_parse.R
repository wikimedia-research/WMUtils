#' @title User agent parsing
#' 
#' @description
#' \code{ua_parse} acts as a connector to
#' \href{https://github.com/tobie/ua-parser}{tobie's ua-parser}, consuming a vector of user agents
#' and returning a data frame, with each field (see 'arguments') as a distinct column.
#' 
#' @param user_agents A vector of unparsed user agents
#' @param fields The elements you'd like to return. Options are "device" (the device code, when known),
#' "os" (the operating system, when known), "browser" (the browser), "browser_major" (the major version of the browser)
#' and browser_minor (the minor version of the browser)
#' 
#' @author Oliver Keyes <okeyes@@wikimedia.org>
#' 
#' @export

ua_parse <- function(user_agents, fields = c("device","os","browser","minor_version","major_version")){
  
  #Handle big objects
  if(length(user_agents) > 2000000){
    
    #If it's bigger than 2m, split and recursively call
    uas <- split(user_agents, ceiling(seq_along(user_agents)/2000000))
    ua_results <- lapply(uas, ua_parse, fields = fields)
    ua_results <- do.call("rbind",ua_results)
    return(ua_results)
  }  
  
  #Run
  parsed_agents <- rpy(x = user_agents, script = file.path(find.package("WMUtils"),"ua_parse.py"), conduit = "tsv")
  
  #Handle NAs and name
  parsed_agents[is.na(parsed_agents)] <- "Other"
  names(parsed_agents) <- c("device","minor_version","major_version","os","browser")
  
  #Limit
  parsed_agents <- parsed_agents[,fields]
  
  #Return
  return(parsed_agents)
}