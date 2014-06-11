dir_remove(path){
  
  system(paste("rm -r", path))
  
  return(invisible())
}