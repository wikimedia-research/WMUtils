#' @title sanitise environments for garbage collection
#' 
#' @description
#' \code{rmall} sanitises environments, removing every object in a specified environment
#' other than those noted in \code{except}, and then (if desired) performs explicit and silent
#' garbage collection.
#' 
#' @param envir the environment you want the sanitising performed on
#' @param except any objects you want preserved from that environment
#' @param gc whether you want a silent garbage collection performed. FALSE by default.
#' 
#' @author Oliver Keyes <okeyes@@wikimedia.org>
rmall <- function(envir, except, gc = FALSE){
  
  #List all objects in the specified environment or namespace
  objs <- ls(name = envir)
  
  #Exclude the things we want to keep
  objs <- objs[!objs %in% except]
  
  #Remove the rest
  rm(list = objs, pos = envir)
  
  #Garbage collect?
  if(gc){
    
    gc(verbose = FALSE)
    
  }
  
  #Return invisibly
  return(invisible())
}