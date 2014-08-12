#'@title convert JSONified python lists into data.frames.
#'
#'@description
#'\code{rpy_df} turns the R lists representing Python lists passed through JSON into R data.frames,
#'handling NULL values along the way.
#'
#'@param list the list you want converted into a data.frame.
#'@param stringsAsFactors whether you want character columns to be converted into factors. This is set as false by default because
#'factors have almost never been the right answer to a problem.
#'@param ... any further parameters you want to push through to data.frame.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'@export

rpy_df <- function(list, stringsAsFactors = FALSE, ...){

  #Handle NULLs
  handled_list <- lapply(list, function(x){
    
    for(i in seq_along(x)){
      
      if(is.null(x[[i]]) == TRUE){
        
        x[[i]] <- NA
      }
    }
    
    return(x)
  })
  
  #Convert
  handled_df <- data.frame(matrix(unlist(handled_list), nrow = length(handled_list), byrow = TRUE),
                           stringsAsFactors = stringsAsFactors, ...)
  
  #Return
  return(handled_df)
}