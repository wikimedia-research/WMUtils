#'@title parse_uuids
#'@description parse App UUIDs out of requestlog URLs
#'
#'@details \code{parse_uuids} takes URLs from the request logs and parses through them hunting for
#'the unique identifiers included in API requests by the Wikimedia Apps. These are then extracted and provided
#'as a vector.
#'
#'In the event that a valid ID cannot be identified, the string "Invalid" is instead returned.
#'
#'@param url_strings a vector of URLs from the request logs.
#'
#'@return a vector of unique IDs, or the string "Invalid" where no valid ID could be identified.
#'
#'@seealso \code{\link{sampled_logs}} and \code{\link{hive_query}} for retrieving request logs;
#'\code{\link{log_strptime}} for handling request log date/times.
#'
#'@export
parse_uuids <- function(url_strings){
  
  #Convert to UTF-8
  url_strings <- iconv(url_strings, to = "UTF-8")
  
  #Split on equals
  url_strings <- strsplit(x = url_strings, split = "=")
  
  #Loop through
  results <- unlist(lapply(url_strings, function(x){
    
    #All UUIDs should have 36 characters
    uuid <- x[nchar(x) == 36]
    
    #If none match, return NA.
    if(length(uuid) == 0){
      
      return("Invalid")
      
    } else if(length(uuid) == 1){
      
      #If it just worked, cool. Return the single uuid
      return(uuid)
    
    } else {
      
      #If there are multiple matches, use a regular expression to look for dashes
      uuid <- uuid[grepl(x = uuid, pattern = "-", fixed = TRUE)]
      
      if(length(uuid) == 1){
        
        return(uuid)
        
      } else if(length(uuid) > 1){
        
        uuid <- uuid[nchar(gsub(x = uuid, pattern = "-", replacement = "")) == 32] #That should be 32 chars.
        
        #No luck sanitising (or too much luck), return an NA
        if(length(uuid) > 1 | length(uuid) == 0){ 
          return("Invalid")
        }
        
        #If it worked, return
        return(uuid)
        
      } else if(length(uuid) == 0){ #No luck with dash-checking, NA.
        
        return("Invalid")
        
      }
    }
        
  }))
  
  #Return results
  return(results)
}