rpy <- function(x, input_file, output_file, script, ...){
  
  #Create input/output files
  dir_path <- paste("/tmp/ua_", make.names(Sys.time()), sep = "")
  dir.create(dir_path)
  input_path <- file.path(dir_path, input_file)
  output_path <- file.path(dir_path, output_file)
  
  #Write to input
  cat(toJSON(x = x), file = input_path)
  
  #Run script
  system(paste("python", script, input_path, output_path))
  
  #Return results
  results <- fromJSON(output_path)
  
  #Remove files
  file.remove(input_path,output_path,dir_path)
  
  #Return
  return(results)
}