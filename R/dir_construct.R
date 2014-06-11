dir_construct <- function(key_term){
  
  #Construct path
  dir_path <- paste("/tmp/",key_term,make.names(Sys.time()), sep = "")
  
  #Create
  dir.create(dir_path)
  
  #Return
  return(dir_path)
}