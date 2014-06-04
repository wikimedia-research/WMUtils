ua_parse <- function(user_agents, fields = c("device","os","browser","browser_major","browser_minor")){
  
  #Check arguments
  fields <- match.arg(arg = fields, choices = c("device","os","browser","browser_major","browser_minor"),
                      several.ok = TRUE)
  if(!is.vector(user_agents)){
    
    stop("This requires a vector of user agents")
    
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