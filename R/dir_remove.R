dir_remove <- function(path){
  
  system(paste("rm -r", path))
  
  return(invisible())
}