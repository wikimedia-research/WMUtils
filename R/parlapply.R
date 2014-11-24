#'@title parlapply
#'@description parallelised lapply wrapper
#'
#'@details parlapply is a wrapper around mclapply, a parallelised version of lapply. It exists because it's
#'often convenient to not have to remember whether you should preschedule or set a seed, or how many
#'cores are okay, or what the damn function for detecting core numbers is, or, or, or.
#'
#'Default settings are to not preschedule, set a seed or allow for recursive calls (you cannot
#'call parlapply inside a parlapply call. That makes everyone sad.) with [total physical cores]/4 cores
#'used by the process.
#'
#'@param X the list to iterate over \code{\link{keysplit}} can be used to conveniently convert a
#'data.frame or data.table into something parallelisable.
#'
#'@param FUN the function you want to run over each element of X.
#'
#'@param ... further arguments to pass to FUN
#'
#'@return a list containing the results of FUN for each element of X.
#'
#'@importFrom parallel mclapply
#'@export
parlapply <- function(X, FUN, ...){
  
  mclapply(X = X, FUN = FUN,
           mc.preschedule = FALSE,
           mc.cores = round(detectCores()/4),
           mc.set.seed = FALSE,
           mc.allow.recursive = FALSE,
           ...)
}