//Handlers for URLs
#include <Rcpp.h>
using namespace Rcpp;

//Lowercase a string
std::string str_tolower(std::string x){
  
  //Create output object
  std::string output;
  int string_size = x.size();
  
  //Loop
  for(int i = 0; i < string_size; i++){
    
    //For each character, lowercase and append
    output += tolower(x[i]);
    
  }
  
  //Return
  return output;
}

//URL filterer
std::string url_filter(std::string url) {
  
  //Remove initial fields
  std::size_t protocol = url.find("://"); //http(s)...
  if((protocol < 0) | (protocol > 6)){
    
    //If that's not present, or isn't present at the /beginning/, this is not a valid URL
    url = "Unknown";
  
  } else {
    
    //Otherwise, remove it
    url = url.substr((protocol+3));
    
    //Limit to hostname
    std::size_t path_start = url.find("/");
    url = url.substr(0, path_start);
    
    //Lowercase, now that we're relying on alpha characters
    url = str_tolower(url);
    
    //Check for www, remove if present
    std::size_t www_check = url.find("www.");

    //If it's present
    if((signed int) www_check != -1){
      url = url.substr(www_check+4);
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
//'@seealso \code{\link{project_extractor}} for extracting Wikimedia language codes and projects.
//'@export
// [[Rcpp::export]]
std::vector< std::string > host_handler(std::vector < std::string > urls) {
  
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
//'@description extracts language and project from a Wikimedia URL
//'
//'@details \code{project_extractor} takes Wikimedia URLs and extracts the language and project
//'(for example, turning "https://en.wikipedia.org"" into "en.wikipedia"). It can handle both current
//'and historic intermediary domains - zero, mobile, wap - and exclude them consistently.
//'
//'@param urls a vector of URLs
//'
//'@return a vector of language and project names, or "Unknown" if a URL cannot be parsed. In the event
//'that a URL can be parsed but you've been silly enough to pass it a non-Wikimedia URL, it will simply
//'return nonsense.
//'
//'@seealso \code{\link{host_handler}} for extracting hostnames generically.
//'@export
//[[Rcpp::export]]
std::vector < std::string > c_project_extractor(std::vector < std::string > urls){
  
  //Note possible options
  std::set < std::string > subdomains = {"mobile","m","wap","zero"};

  //Grab size, construct an output vector and holding object
  int input_length = urls.size();
  std::vector< std::string > output(input_length);
  std::string holding;
  std::string lang_code;
  std::string project;
  
  //For each entry...
  for(int i = 0; i < input_length; i++) {
    
    //Retrieve the stripped hostname
    holding = url_filter(urls[i]);
    
    if(holding != "Unknown"){
      
      //Grab the language prefix
      std::size_t lang_loc = holding.find(".");
      lang_code = holding.substr(0,lang_loc);
      holding = holding.substr(lang_loc+1);
      
      //Split again to extract the (possible) subdomain
      std::size_t possible_subdomain = holding.find(".");
      project = holding.substr(0,possible_subdomain);
      holding = holding.substr(possible_subdomain+1);
      
      //If the extracted string does not appear in 'subdomains', grab the second chunk - otherwise, the third
      if(subdomains.find(project) == subdomains.end()) {
        output[i] = lang_code + "." + project;
      } else {
        std::size_t definite_subdomain = holding.find(".");
        output[i] = lang_code + "." + holding.substr(0,definite_subdomain);
      }
      
    } else {
      
      output[i] = "Unknown";
      
    }
  }
  
  //Return
  return output;
}