#'@title paste without a separator
#'@description What it says on the tin. Necessary for jsonlite and does not exist in all
#'R versions, sadly
#'
#'@param ... arguments to pass into paste()
#'
#'@export
paste0 <- function(...){
  
  paste(..., sep = "")
  
}