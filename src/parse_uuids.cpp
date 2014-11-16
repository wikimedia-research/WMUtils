#include <Rcpp.h>
using namespace Rcpp;

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
    if(ID_loc != -1){
      
      //If so, extract the next 
      output[i] = urls[i].substr(ID_loc+13,ID_loc+49);
      
    } else {
      
      //Otherwise, no valid ID
      output[i] = "Invalid";
      
    }
    
  }
  return output;
}