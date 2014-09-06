text_read <- function(filename){
  
  #Open text connection
  rpy_con <- file(description = filename, open = "r")
  
  #Read in
  results <- readLines(con = rpy_con)
  
  #Close and return
  close(rpy_con)
  return(results)
}

text_write <- function(object, filename){
  
  #Open text connection
  rpy_con <- file(description = filename, open = "w")
  
  #Write
  writeLines(text = object, con = rpy_con)
  
  #Close and return
  close(rpy_con)
  return(TRUE)
  
}

json_read <- function(filename){
  
  #Read from JSON
  results <- fromJSON(txt = filename)
  
  #Return
  return(results)
}

json_write <- function(object, filename){
  
  #Write to JSON
  cat(toJSON(x = object), file = filename)
  
  #Return true
  return(TRUE)
  
}

tsv_read <- function(filename){
  
  #Read from TSV
  results <- read.delim(file = filename, as.is = TRUE)
  
  #Return
  return(results)
  
}

tsv_write <- function(object, filename){
  
  #Write out a TSV
  write.table(object, file = filename,
              quote = TRUE, row.names = FALSE,
              sep = "\t")
  
  #Return true
  return(TRUE)
  
}