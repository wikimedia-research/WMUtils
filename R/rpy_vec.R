#'@title
#'rpy-to-vector
#'
#'@description
#'\code{rpy_vec} converts the results of rpy calls into a vector after sanitising them for missing values
#'
#'@param list the rpy-produced list you want converted into a vector
#'#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@seealso \code{\link{rpy_df}} for conversion of rpy results into vectors, and \code{\link{rpy}} itself.
#'@export

rpy_vec <- function(list){
  
  #Handle NULLs
  handled_list <- lapply(list, function(x){
    
    for(i in seq_along(x)){
      
      if(is.null(x[[i]]) == TRUE){
        
        x[[i]] <- NA
      }
    }
    
    return(x)
  })
  
  #Unlist
  handled_vector <- unlist(handled_list)
  
  #Return
  return(handled_vector)
}