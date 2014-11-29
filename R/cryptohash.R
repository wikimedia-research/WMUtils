#'@title cryptohash
#'
#'@description cryptographically hash a character vector, or something coercable into one.
#'
#'@param x a vector of strings, or an object that can be coerced into a vector of strings.
#'
#'@param algorithm the hashing algorithm to apply to each string. Options are "md5", "sha1", "sha256",
#'and "sha512".
#'
#'@param include_rand whether or not to include a pseudorandom element as part of each string; set to FALSE
#'by default.
#'
#'@param na_rm whether or not it is acceptable to remove NA values from the vector. Please note that
#'in the event that NA values are found, and na.rm is FALSE, the function call will simply terminate.
#'Set to FALSE by default.
#'
#'@examples
#'cryptohash("foo", algorithm = "md5")
#'cryptohash("foo", algorithm = "md5", include_rand = TRUE)
#'cryptohash(c("foo",NA), algorithm = "sha1", na_rm = TRUE)
#'
#'@return a vector of cryptographic hashes, the length of the input vector (or shorter if
#'na_rm is set to TRUE)
#'
#'@export
cryptohash <- function(x, algorithm, include_rand = FALSE, na_rm = FALSE){
  
  #If x is not a character vector, turn it into one and warn
  if(!is.character(x)){
    x <- as.character(x)
    warning("x is not a character vector. Attempting to convert it into one.")    
  }
  
  #If x contain NAs...
  if(any(is.na(x))){
    if(!na_rm){
      #..and that hasn't been accounted for with na.rm, stop
      stop("x contained NA values and cannot be hashed. Remove the invalid elements, or set na_rm to TRUE")
    } else {
      x <- x[!is.na(x)]
      if(length(x) == 0){
        stop("After removing NA values, no values were left.")
      }
    }
  }
  
  #If include_rand is true...well, include a rand.
  if(include_rand){
    
    #NULL out the seed to avoid consistency between runs
    set.seed(NULL)
    
    #Pseudorandomly select a number from within that. Starting at 3, because 1 and 2 are
    #disturbingly similar between runs.
    rand_val <- as.character(.Random.seed[sample(3:length(.Random.seed),1)])
    
    #NULL out the seed yet again to avoid the seed values being recoverable.
    set.seed(NULL)
    
    #Append to each string
    x <- paste0(x, rand_val)
  }
  
  #After all that, hash
  output <- c_cryptohash(x = x, algorithm = algorithm)
  
  #Return
  return(output)
  
}