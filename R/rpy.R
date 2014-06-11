rpy <- function(x, script, ...){
  
  #Create input/output files
  dir_path <- paste("/tmp/rpy_", make.names(Sys.time()), sep = "")
  dir.create(dir_path)
  input_path <- file.path(dir_path, "input.json")
  output_path <- file.path(dir_path, "output.json")
  
  #Write to input
  cat(toJSON(x = x), file = input_path)
  
  #Run script
  system(paste("python", script, input_path, output_path, ...))
  
  #Return results
  results <- fromJSON(output_path)
  
  #Remove folder
  dir_remove(dir_path)
  
  #Return
  return(results)
}