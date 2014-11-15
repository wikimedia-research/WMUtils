#include <Rcpp.h>
using namespace Rcpp;

//URL filterer
std::string url_filter(std::string url) {
  
  //Remove initial fields
  std::size_t protocol = url.find_first_of("/"); //http(s)...
  if(protocol == -1){
    
    //If that's not present, this is not a valid URL
    url = "Unknown";
  
  
  } else {
    
    //Otherwise, remove it
    url = url.substr((protocol+2));
    
    //Limit to hostname
    std::size_t path_start = url.find_first_of("/");
    url = url.substr(0, path_start);
    
    //Check for www, remove if present
    std::size_t www = url.rfind("www.");
    
    //If it's present
    if(www != -1){
      url = url.substr(www+4);
    }
    
  }
  
  return url;
}

//'@title host_handler
//'@details extracts the hostname, TLD and subdomains from a generic URL
//'
//'@description
//'\code{host_handler} is a domain-neutral host extractor for URLs, excluding generic prefixes (http, https, www)
//'and paths/queries.
//'
//'@param urls a character vector of URLs
//'
//'@return a vector of hostnames, or "Unknown" if the hostname was invalid
//'
//'@export
// [[Rcpp::export]]
std::vector< std::string > host_handler(std::vector< std::string > urls) {
  
  //Grab size, construct an output vector
  int input_length = urls.size();
  std::vector< std::string > output(input_length);
  
  //For each input URL...
  for(int i = 0; i < input_length; i++) {
    
    //Limit to hostname
    output[i] = url_filter(urls[i]);
    
  }
  
  //Return
  return output;
}

//'@title project_extractor