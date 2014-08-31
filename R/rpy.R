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
#'One possible point of confusion is conversion between types; R has one set of data types, Python has another.
#'The mapping between R and Python types is:
#'\tabular{cll}{
#'  \tab \strong{R} \tab \strong{Python}\cr
#'  \tab Data Frame \tab Dictionary\cr
#'  \tab Vector \tab List\cr
#'  \tab Named Vector \tab Dictionary\cr
#'  \tab List \tab List\cr
#'  \tab Matrix \tab List\cr
#'  \tab Array \tab Cannot be turned into JSON\cr
#'}
#'The only other thing to realise is that the Python script must read the input file in as a JSON object,
#'and write the output as a JSON object, since that's the mutually-understood format that's used to communicate
#'between the two languages.
#'
#'@author Oliver Keyes <okeyes@@wikimedia.org>
#'
#'@importFrom jsonlite toJSON fromJSON
#'@export

rpy <- function(x, script, ...){
  
  #Create input/output files
  input_file <- tempfile(fileext = ".json")
  output_file <- tempfile(fileext = ".json")
  
  #Write to input
  cat(toJSON(x = x), file = input_file)
  
  #Run script
  ignore <- system(command = paste("python", script, "-i", input_file, "-o", output_file, ...))
  
  #Return results
  tryCatch(expr = {
    
    results <- fromJSON(txt = output_file)
    
  }, error = function(e){
    
    warning("Data returned from the Python script could not be read in. Error in python?
             Full error: ", e)
    
    results <- NULL
    
  })
  
  #Remove files
  suppressWarnings(expr = {
    
    warnings <- try(expr = {file.remove(output_file, input_file)},
                    silent = TRUE)
    
  })
  
  #Return
  return(results)
}