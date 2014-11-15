#include <Rcpp.h>
using namespace Rcpp;

//'@title xff_handler
//'@description extracts the last IP address from a chain of IPs reported through the x_forwarded_for field
//'
//'@param ips a vector of IP chains
//'
//'@return a vector of either the last IP in a chain, or the IP if no chain was present
// [[Rcpp::export]]
std::vector< std::string > xff_handler(std::vector< std::string > ips) {
   
  //Grab size, construct an output vector
  int input_length = ips.size();
  std::vector< std::string > output(input_length);
  
  //For each input IP...
  for(int i = 0; i < input_length; i++) {
    
    //Identify where ", " appears
    std::size_t found = ips[i].rfind(", ");
    
    //If it doesn't, no sequence - return the ip
    if(found == -1){
      
      output[i] = ips[i];
    
    //Otherwise, return the sequence /after/ the last match.
    } else {
      
      output[i] = ips[i].substr(found+2);
      
    }
  }
  
  //Return
  return output;
}
