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
    
    namespace_names <- namespace_names[namespace_names$language == language & namespace_names$project == project,]
    
  }
  
  #Which direction do they want to convert in? If code-to-name..
  if(max(nchar(x)) > 2){
    
    #Construct output
    output <- character(length(x))
    
    #We have to loop, because merge() doesn't preserve the original order. Bah.
    for(i in seq_along(output)){
      
      output[i] <- namespace_names$name[namespace_names$namespace == x[i]]
      
    }
    
  } else {
    
    #Alternately, if name-to-code, do the same thing but, y'know, backwards.
    output <- numeric(length(x))
    
    #We have to loop, because merge() doesn't preserve the original order. Bah.
    for(i in seq_along(output)){
      
      output[i] <- namespace_names$namespace[namespace_names$name == x[i]]
      
    }
  }
  
  #Either way, return
  return(output)
  
}