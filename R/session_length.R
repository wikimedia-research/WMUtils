#'@title
#'session_length
#'
#'@description
#'Session counting function
#' 
#'@param timestamps a vector of inter-time values.
#' 
#'@param local_minimum the threshold (in seconds) to split out a new session on. Set to 3600
#' by default.
#' 
#'@details
#'\code{session_length} takes a vector of intertime values (generated via \code{\link{intertimes}},
#'or in any other way you see fit), splits them into sessions, and calculates the approximate
#'length (in seconds) of each session.
#'
#'@return a vector of session length counts, in seconds.
#' 
#'@seealso
#'\code{\link{intertimes}}, for generating inter-time values, and \code{\link{session_count}} for
#'simply counting the number of sessions.
#' 
#'@export
session_length <- function(x, local_minimum = 3600){
  
  #If there's only one timestamp, return twice that
  if(length(timestamps) == 1){
    
    return(2*timestamps)
    
  }
  
  #Otherwise, instantiate holding variables
  var_of_holding <- numeric(1)
  var_of_summing <- numeric(1)
  
  for(i in seq_along(timestamps)){
    
    #For each variable, if it's < local_minimum, add to vars
    if(timestamps[i] <= local_minimum){
      
      var_of_holding <- var_of_holding + timestamps[i]
      var_of_summing <- var_of_summing + 1
      
    } else {
      
      #Otherwise, recurse and break
      recursed_output <- session_length(timestamps = timestamps[i:length(timestamps)],
                                        local_minimum = local_minimum)
      break
    }
    
  }
  
  #Either way, sum
  result <- var_of_holding + (var_of_holding/var_of_summing)
  
  #If there's a recursed output, include that
  if(exists("recursed_output")){
    
    result <- c(result, recursed_output)
  }
  
  #Return
  return(result)
}