dir_remove(path){
  
  system(paste("rm -", path))
  
  return(invisible())
}