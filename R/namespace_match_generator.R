#'@title
#'namespace name/number retrieval
#'
#'@description
#'\code{namespace_match_generator} generates a localised list of namespace names and the equivalent IDs,
#'and saves it to file. This is then used by \link{\code{namespace_match}}
#'
#'@param to_return whether or not to return the dataset, as well as save it to file.
#'
#'@details
#'namespace_match_generator queries the various Wikimedia APIs to build up a dataset of what the localised
#'namespace names are on each project. For this reason it needs internet access - don't bother using it on
#'stat1002, for example.
#'
#'@seealso
#'\link{\code{namespace_match}}, which uses the resulting dataset to perform namespace name/ID matching.
#'
#'@return Either the value TRUE, if to_return is FALSE, or a data.table containing the project dbname,
#'language name, project type, namespace ID, and localised namespace name.
#'
#'@export
namespace_match_generator <- function(to_return = FALSE){
  
  #Function for retrieving the JSON
  json_retrieve <- function(api_url){
    
    #Open connection, grab, close
    con <- url(api_url)
    blob <- readLines(con = con, warn = FALSE)
    close(con)
    
    #Parse as JSON
    result <- fromJSON(blob)$query$namespaces
    
    #Extract actual, you know, values.
    values <- unlist(lapply(result, function(x){return(x$'*')}))
    
    #Build data.table
    result <- data.table(namespace = names(values), name = values)
    result$namespace <- as.numeric(result$namespace)
    
    #Return
    return(result)
  }
  
  #Retrieve the list of URLs, codes, etc, etc.
  initial_dataset <- mysql_query("SELECT lang_name AS language,
                              code AS project_type,
                              wiki AS db,
                              url FROM wiki_info;","staging")
  
  #Limit to the ones that are live and kicking, as it were.
  dead_wikis <- unlist(lapply(c("http://noc.wikimedia.org/conf/closed.dblist",
                         "http://noc.wikimedia.org/conf/deleted.dblist",
                         "http://noc.wikimedia.org/conf/fishbowl.dblist",
                         "http://noc.wikimedia.org/conf/private.dblist",
                         "http://noc.wikimedia.org/conf/special.dblist"),
                       function(x){
                         
                         #Retrieve wikis
                         con <- url(x)
                         wikis <- readLines(con = con, warn = FALSE)
                         close(con)
                         
                         #Return
                         return(wikis)
                       }))
  initial_dataset <- initial_dataset[!initial_dataset$db %in% dead_wikis,]
  
  #Construct queryable URLs
  initial_dataset$url <- paste0(initial_dataset$url,"/w/api.php?action=query&meta=siteinfo&format=json&siprop=namespaces")
  initial_dataset$url <- gsub(x = initial_dataset$url, pattern = "https", replacement = "http")
  
  #Retrieve names
  namespace_names <- initial_dataset[,j = json_retrieve(url), by = c("language","project_type","db")]
  
  #Write to disk
  save(namespace_names, file = file.path(find.package("WMUtils"),"data","namespace_names.RData"))
  
  #Return if necessary
  if(to_return){
    
    return(namespace_names)
    
  }
  
  #Return TRUE if not
  return(TRUE)
}