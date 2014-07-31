#' @title User agent parsing
#' 
#' @description
#' \code{ua_parse} acts as a connector to \href{https://github.com/tobie/ua-parser}{tobie's ua-parser},
#' consuming a vector of user agents and returning a data frame, with each field (see 'arguments') as a distinct column.
#' This can be usefully parsed by \code{\link{rpy_df}} or \code{\link{rpy_vec}} to handle the NULL entries
#' that result from R's interpretation of Python's 'None' type, and turn it into a more useful object than
#' an endlessly long list.
#' 
#' @param user_agents A vector of unparsed user agents
#' @param fields The elements you'd like to return. Options are "device" (the device code, when known),
#' "os" (the operating system, when known), "browser" (the browser), "browser_major" (the major version of the browser)
#' and browser_minor (the minor version of the browser)
#' 
#' @author Oliver Keyes <okeyes@@wikimedia.org>
#' 
ua_parse <- function(user_agents, fields = c("device","os","browser","browser_major","browser_minor")){
  
  #Check arguments
  fields <- match.arg(arg = fields, choices = c("device","os","browser","browser_major","browser_minor"),
                      several.ok = TRUE)
  
  if(!is.vector(user_agents)){
    
    stop("This requires a vector")
    
  }
  
  #Handle big objects
  if(length(user_agents) > 2000000){
    
    #If it's bigger than 2m, split and recursively call
    uas <- split(user_agents, ceiling(seq_along(user_agents)/2000000))
    ua_results <- lapply(uas, ua_parse, fields = fields)
    ua_results <- do.call("rbind",ua_results)
    return(ua_results)
  }
  
  #Convert
  user_agents <- iconv(user_agents, to = "UTF-8")
  
  #Handle NAs
  user_agents[is.na(user_agents)] <- ""
  
  #Run
  returned_UAs <- rpy(x = user_agents, script = file.path(find.package("WMUtils"),"ua_parse.py"))
  
  #Handle NULLs
  returned_UAs <- lapply(returned_UAs, function(x){
    
    for(i in seq_along(x)){
      
      if(is.null(x[[i]]) == TRUE){
        
        x[[i]] <- "Other"
      }
    }
    
    return(x)
  })
  
  #Convert into a data frame
  parsed_uas <- data.frame(matrix(unlist(returned_UAs), nrow = length(returned_UAs), byrow = TRUE), stringsAsFactors = FALSE)
  
  #Rename
  names(parsed_uas) <- names(returned_UAs[[1]])
  
  #Limit
  parsed_uas <- parsed_uas[,fields]
  
  #Return
  return(parsed_uas)
}