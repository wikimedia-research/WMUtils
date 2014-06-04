rpy_vec <- function(list){
  
  #Handle NULLs
  handled_list <- lapply(list, function(x){
    
    for(i in seq_along(x)){
      
      if(is.null(x[[i]]) == TRUE){
        
        x[[i]] <- "NA"
      }
    }
    
    return(x)
  })
  
  #Unlist
  handled_vector <- unlist(handled_list)
  
  #Return
  return(handled_vector)
}