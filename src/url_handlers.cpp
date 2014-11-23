//Handlers for URLs

#include <Rcpp.h>
using namespace Rcpp;

//Lowercase a string
std::string str_tolower(std::string x){
  
  //Create output object
  std::string output;
  string_size = x.size();
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
    std::size_t www = url.find("www.");
    
    //If it's present
    if(www >= 0){
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
std::vector < std::string > project_extractor(std::vector < std::string > urls){
  
  //Note possible options
  std::set < std::string > subdomains;
  subdomains.insert("mobile");
  subdomains.insert("m");
  subdomains.insert("wap");
  subdomains.insert("zero");

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

//'@title parse_uuids
//'@description parse App UUIDs out of requestlog URLs
//'
//'@details \code{parse_uuids} takes URLs from the request logs and parses through them hunting for
//'the unique identifiers included in API requests by the Wikimedia Apps. These are then extracted and provided
//'as a vector.
//'
//'In the event that a valid ID cannot be identified, the string "Invalid" is instead returned.
//'
//'@param url_strings a vector of URLs from the request logs.
//'
//'@return a vector of unique IDs, or the string "Invalid" where no valid ID could be identified.
//'
//'@seealso \code{\link{sampled_logs}} and \code{\link{hive_query}} for retrieving request logs;
//'\code{\link{log_strptime}} for handling request log date/times.
//'
//'@export
// [[Rcpp::export]]
std::vector< std::string > parse_uuids(std::vector< std::string > urls) {
  
  //Measure input size and create output
  int input_length = urls.size();
  std::vector< std::string > output(input_length);
  
  //For each input hostname...
  for(int i = 0; i < input_length; i++) {
    
    //Extract the location of AppInstallID
    std::size_t ID_loc = urls[i].find("appInstallID=");
    
    //Does it exist?
    if(ID_loc >= 0){
      
      //If so, extract the next 
      output[i] = urls[i].substr(ID_loc+13,ID_loc+49);
      
    } else {
      
      //Otherwise, no valid ID
      output[i] = "Invalid";
      
    }
    
  }
  return output;
}