#'@title
#'namespace name/number matching
#'
#'@description
#'\code{namespace_match} allows you to match namespace names to the appropriate namespace ID numbers, or vice
#'versa, in any language.
#'
#'@param x a vector of namespace names or numbers
#'
#'@param code which project's names to use as the basis for the conversion. Set to "enwiki" by default.
#'
#'@param language see 'details' - set to NULL by default
#'
#'@param project_type see 'details' - set to NULL by default
#'
#'@param use_API whether to rebuild the data fresh from the API, or use the version that comes with WMUtils.
#'note that API rebuilding will update the version stored with WMUtils, but won't work at all on stat1002.
#'Because there's no internet on stat1002.
#'
#'@details
#'namespace_match takes a vector of namespace ID numbers or namespace names, and matches them to...well, the one
#'you didn't provide. To do this it relies on a .RData file of the globally used namespace IDs and local names.
#'
#'To match your names/IDs with the project you want them localised to, you can provide either \code{code}, which
#'matches the format used in the \code{wiki_info} table and the NOC lists, or both language and project_type,
#'where language is the English-language name for the project language, and project_type is "wiki", "wikisource",
#'or so on, following the format used in the \code{wiki_info} table.
#'
#'@seealso
#'\code{\link{namespace_match_generator}}, the function that (re)generates the dataset. It can be directly
#'called.
#'
#'@return a vector containing the IDs or names, whichever you wanted.
#'
#'@export
namespace_match <- function(x, code = "enwiki", language = NULL, project_type = NULL, use_API = FALSE){
  
  #Do we use the API or not? If so, call namespace_match_generator. If not, read in the .RData
  if(use_API){
    
    namespace_names <- namespace_match_generator(to_return = TRUE)
    
  } else {
    
    load(file.path(find.package("WMUtils"),"data","namespace_names.RData"))
    
  }
  
  #Either way, subset
  if(is.null(language)){
    
    namespace_names <- namespace_names[namespace_names$db == code,]
    
  } else {
    
    namespace_names <- namespace_names[namespace_names$language == language & namespace_names$project == project_type,]
    
  }
  
  #Which direction do they want to convert in? If code-to-name..
  if(max(nchar(x)) > 2){
    
    #Construct output
    output <- character(length(x))
    
    #We have to loop, because merge() doesn't preserve the original order. Bah.
    for(i in seq_along(output)){
      
      try({
      output[i] <- namespace_names$namespace[namespace_names$name == x[i]]
      }, silent = TRUE)
    }
    
    output[!x %in% namespace_names$name] <- "No local name"
    
  } else {
    
    #Alternately, if name-to-code, do the same thing but, y'know, backwards.
    output <- numeric(length(x))
    
    #We have to loop, because merge() doesn't preserve the original order. Bah.
    for(i in seq_along(output)){
      
      try({
        output[i] <- namespace_names$name[namespace_names$namespace == x[i]]
      }, silent = TRUE)
    }
    
    output[!x %in% namespace_names$namespace] <- NA

  }
  
  #Either way, return
  return(output)
  
}