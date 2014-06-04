rpy_df <- function(list, stringsAsFactors = FALSE, ...){

  #Handle NULLs
  handled_list <- lapply(list, function(x){
    
    for(i in seq_along(x)){
      
      if(is.null(x[[i]]) == TRUE){
        
        x[[i]] <- "NA"
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