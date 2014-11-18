#include <Rcpp.h>
#include <GeoIP.h>
using namespace Rcpp;

//Convert const char pointer to string
std::string const_pt_to_string(const char *pt){
  std::string output(pt);
  output = pt;
  return output;
}

//String to const char pointer
const char * string_to_const_pt(std::string str){
  char * output = new char [str.length()+1];
  strcpy (output, str.c_str());
  return output;
}

//'@title c_geo_country
//'@description geolocation to country-level, via C++
//'@details HIGHLY EXPERIMENTAL. A connector to MaxMind's C API.
//'@export
// [[Rcpp::export]]
std::vector < std::string > c_geo_country (std::vector < std::string > ip_addresses) {
  
  //Load the IPv4/6 files - it'll conveniently throw an error if that fails. Yay!
  GeoIP *gi_4 = GeoIP_open("/usr/share/GeoIP/GeoIP.dat", GEOIP_MEMORY_CACHE);
  GeoIP *gi_6 = GeoIP_open("/usr/share/GeoIP/GeoIPv6.dat", GEOIP_MEMORY_CACHE);

  //Check input size, create output
  int input_size = ip_addresses.size();
  std::vector < std::string > output(input_size);
  
  //Holding object
  const char *returnedCountry;
  
  //For each IP...
  for(int i = 0; i < input_size; i++){
    
    //If it looks like an IPv4, run it through the IPv4 database
    if(ip_addresses[i].find(".") != -1){
      returnedCountry = GeoIP_country_code_by_addr(gi_4, string_to_const_pt(ip_addresses[i]));
    } else {
      //Otherwise, IPv6
      returnedCountry = GeoIP_country_code_by_addr(gi_6, string_to_const_pt(ip_addresses[i]));
    }
    
    //Either way, if it's NULL, save "Invalid"
    if(returnedCountry == NULL){
      
      output[i] = "Invalid";
      
    } else {
      
      //Otherwise, do some hideous type conversion
      output[i] = const_pt_to_string(returnedCountry);
    }

  }
  
  //Return
  return output;
}

//'@title xff_handler
//'@description extracts the last IP address from a chain of IPs reported through the x_forwarded_for field
//'
//'@details our x_forwarded_for fields contain not just single IP addresses, but sometimes /chains/ of IP addresses,
//'where users have gone through multiple levels of proxying. \code{xff_handler} extracts the earliest IP address in
//'such chains or, when a chain is not present, simply returns the (only) IP found. It is called in the various
//'geolocation functions in WMUtils, but may also be useful for extracting IPs in the case of (for example)
//'generating pseudo-unique fingerprints.
//'
//'@param ips a vector of IP chains
//'
//'@return a vector of either the last IP in a chain, or the IP if no chain was present.
//'
//'@export
// [[Rcpp::export]]
std::vector< std::string > xff_handler(std::vector< std::string > ips) {
   
  //Grab size, construct an output vector
  int input_length = ips.size();
  std::vector< std::string > output(input_length);
  
  //For each input IP...
  for(int i = 0; i < input_length; i++) {
    
    //Identify where ", " appears
    std::size_t last_loc = ips[i].rfind(", ");
    
    //If it doesn't, no sequence - return the ip
    if(last_loc == -1){
      
      output[i] = ips[i];
    
    //Otherwise, return the sequence /after/ the last match.
    } else {
      
      output[i] = ips[i].substr(last_loc+2);
      
    }
  }
  
  //Return
  return output;
}