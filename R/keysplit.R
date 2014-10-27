#'@title keysplit
#'@description split a data.frame or data.table for parallel processing over a key column
#'
#'@details Splitting a data frame into a list is easy, which is good; when you're performing listwise operations,
#'particularly through the parallel package, a list is the class of choice. Splitting a data.frame into a list
#'when you want to keep all the rows associated with unique values in a column together is /difficult/.
#'
#'\code{keysplit} handles this; given a data.frame or data.table and the name of a column that contains
#'a key, it splits the object into a list, making sure that all rows associated with a specific key value
#'are found in the same list element each time.
#'
#'@param obj the data.frame or data.table. In the event that it's a data.frame, it will be coerced into a
#'data.table
#'
#'@param key_col the column storing the key.
#'
#'@param pieces how many pieces to split \code{obj} into. By default it's a quarter of the available physical
#'CPU cores, rounded, since the intent is for \code{keysplit} to be used in relation to parallel processing.
#'
#'@seealso \code{\link{parlapply}} a wrapper for the parallelised lapply function.
#'
#'@export
keysplit <- function(obj, key_col, pieces = round(detectCores()/4)){
  
  #Is it a data.table? No? Too bad.
  if(!"data.table" %in% class(obj)){
    obj <- as.data.table(obj)
  }
  
  #Set names. This is dumb because data.tables and their expression evaluation == dumb.
  setnames(obj, key_col, "uuid")
  
  #Grab unique keys and randomly sort them
  uniques <- unique(x = obj[,eval(quote(uuid))])
  uniques <- sample(x = uniques, size = length(uniques))
  
  #Construct a data.table containing the random uniques and a randomly generated seed.
  uniques <- data.table(col1 = uniques,
                        group = rep_len(x = 1:pieces, length.out = length(uniques)))
  setnames(x = uniques, old = 1, new = "uuid")
  
  #Merge it into obj
  obj <- merge(x = obj, y = uniques, all.x = TRUE, by = "uuid")
  setnames(obj, "uuid", key_col)
  out_obj <- split(x = obj, f = obj$group)
  
  #Kill group
  out_obj <- lapply(out_obj, function(x){return(x[,"group" := NULL])})
  
  #Return
  return(out_obj)
}