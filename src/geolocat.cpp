#include <Rcpp.h>
#include <GeoIP.h>
using namespace Rcpp;

//HIGHLY EXPERIMENTAL and currently broken. Ignore.
// [[Rcpp::export]]
std::vector < std::string > c_geo_country (std::vector < std::string > ip_addresses) {
  
  //Load the IPv4/6 files - it'll conveniently throw an error if that fails. Yay!
  GeoIP *gi_4 = GeoIP_open("/home/ironholds/Code/GeoIP.dat", GEOIP_MEMORY_CACHE);
  GeoIP *gi_6 = GeoIP_open("/home/ironholds/Code/GeoIP.dat", GEOIP_MEMORY_CACHE);

  //Check input size, create output
  int input_size = ip_addresses.size();
  std::vector < std::string > output(input_size);
  
  //Holding objects
  std::string holding;
  const char *returnedCountry;
  
  //For each IP...
  for(int i = 0; i < input_size; i++){
    
    //Turn the IP into a const char
    holding = ip_addresses[i];
    char * temp_const = new char [holding.length()+1];
    strcpy (temp_const, holding.c_str());
    
    //If it looks like an IPv4, run it
    if(ip_addresses[i].find(".") != -1){

      returnedCountry = GeoIP_country_code_by_addr(gi_4, temp_const);
      
    } else {
      
      returnedCountry = GeoIP_country_code_by_addr(gi_6, temp_const);
      
    }
    output[i] = returnedCountry;
  }
  
  //Return
  return output;
}
