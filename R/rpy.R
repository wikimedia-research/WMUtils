#'@title
#'R-to-Python-to-R conduit
#'
#'@description
#'\code{rpy} seamlessly moves R objects into Python environments, runs a script of your choice over them, and pulls the results back in.
#'
#'@param x the R object to transfer to python
#'
#'@param script the file location of the Python script.
#'
#'@param conduit whether you would like txt, tsv or json as the transfer medium (see "integrating with a Python script)
#'
#'@param ... any other arguments to pass to the Python script
#'
#'@details
#'There's a fairly common scenario for R programmers: you're writing your code, and suddenly realise that what
#'you want to do is most efficiently (or only!) handled by a Python library.
#'Forced to choose between implementing it in R and writing a hideous bash script to pipe an R script's stdout
#'into a Python script's stdin into another R script's stdin, you opt for the latter, cursing all the way.
#'
#'rpy allows you to avoid this pain. Instead, you simply call rpy, providing the name of the R object you want
#'transferred to Python, and the Python script you want to run over it. The script then chugs away,
#'and the results are returned as an appropriate R object.
#'
#'@section integrating with a Python script:
#'Integrating this function with your Python script is fairly simple; it sends off the full names of the input and output files,
#'along with any further arguments you pass in, as command line arguments to the script.
#'These can be read with \code{argparse}; the input file is preceded by the command-line argument \code{-i},
#'the output file \code{-o}, and any further arguments follow that pattern.
#'
#'The output at the R end comes in one of three formats; a .txt, a .tsv, and a JSON blob.
#'
#'In all cases the objects come without column names; .txt is most appropriate for a vector, .tsv for a
#'vector or data.frame, and JSON for, well, anything - the reason for the existence of non-JSON input/output
#'streams is that it allows for per-line processing at the Python end, handling situations where there are
#'encoding mismatches between the two languages.
#'
#'In terms of what rpy accepts coming /back/ from Python: a .txt, a .tsv, or a JSON blob: input and output
#'methods are currently paired. In the case of a TSV, blank lines are fine, and a header is not looked for.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@importFrom jsonlite toJSON fromJSON
#'@export

rpy <- function(x, script, conduit = "text", ...){
  
  #Select appropriate functions
  rpy_funs <- rpy_selector(conduit)
  
  #Create input/output files
  input_file <- tempfile(fileext = rpy_funs$ending)
  output_file <- tempfile(fileext = rpy_funs$ending)  
  
  #Write out
  rpy_funs$write(object = x, filename = input_file)
  
  #Run script
  ignore <- system(command = paste("python", script, "-i", input_file, "-o", output_file, ...), intern = TRUE)
  
  #Grab results
  tryCatch(expr = {
    
    results <- rpy_funs$read(filename = output_file)
    
  }, error = function(e){
    
    warning("The Python script could not be run: R error message was", e)
    return(NULL)
    
  })
  
  #Remove files
  file.remove(output_file, input_file)
  
  #Return
  return(results)
}