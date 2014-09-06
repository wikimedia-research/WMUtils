rpy_selector <- function(conduit){
  
  #Which scope shall I take?
  switch(conduit, 
         text = {
           
           #If text, pass through text-based functions
           rpy_funs <- list(read = text_read,
                            write = text_write,
                            ending = ".txt")
           
         },
         
         json = {
           
           rpy_funs <- list(read = json_read,
                            write = json_write,
                            ending = ".json")
           
         },
         
         tsv = {
           
           rpy_funs <- list(read = tsv_read,
                            write = tsv_write,
                            ending = ".tsv")
           
         }, {
           
           stop("No valid file format specified. See ?rpy")
           
         })
  
  #Return the resulting list
  return(rpy_funs)
  
}