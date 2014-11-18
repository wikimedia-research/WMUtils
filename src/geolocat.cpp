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