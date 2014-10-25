#'@title device_classifier
#'@description classifies devices that come out of ua_parse
#'
#'@description \code{\link{ua_parse}} doesn't output device /classes/, merely devices. While this is
#'useful for spider identification, it can make it a pain to work out if "GT-I9300" is a phone, or
#'a tablet, or neither.
#'
#'\code{device_classifier} takes a vector of devices output by ua_parse and classifies them. Classes are
#'"Phone", "Tablet" or "Other".
#'
#'@param devices a vector of devices, output by ua_parse
#'
#'@return a character vector of "Phone", "Tablet" or "Other"
#'
#'@seealso \code{\link{ua_parse}} for user agent parsing.
#'
#'@export
device_classifier <- function(devices){
  
  #Load device classes
  load(file.path(find.package("WMUtils"),"data","devices.RData"))
  
  #Create output vector
  output <- character(length(devices))
  
  #For each type, classify!
  output[devices %in% mobile_devices] <- "Phone"
  output[devices %in% tablet_devices] <- "Tablet"
  output[output == ""] <- "Other"
  
  #Return
  return(output)
  
}