#include <Rcpp.h>
#include <GeoIP.h>
#include <GeoIPCity.h>
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
    if((signed int) last_loc != -1){
      
      output[i] = ips[i];
    
    //Otherwise, return the sequence /after/ the last match.
    } else {
      
      output[i] = ips[i].substr(last_loc+2);
      
    }
  }
  
  //Return
  return output;
}

//'@title geo_country
//'@description Country-level geolocation
//'
//'@details
//'\code{geo_country} geolocates IP addresses to the country level, providing the
//'\href{https://en.wikipedia.org/wiki/ISO_3166-2}{ISO 3166-2} code for the resulting country.
//'It uses \href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database}.
//'
//'@param ips a vector of IP addresses
//'
//'@return a vector of country names. NULL or invalid responses from the API will be replaced with the string "Invalid".
//'
//'@author Oliver Keyes <okeyes@@wikimedia.org>
//'
//'@seealso \code{\link{geo_city}} for city-level identification, \code{\link{geo_region}} for region-level,
//'\code{\link{geo_tz}} for tzdata-compatible timezone identification and \code{\link{geo_netspeed}} for connection
//'type detection.
//'
//'@export
// [[Rcpp::export]]
std::vector < std::string > geo_country (std::vector < std::string > ip_addresses) {
  
  //Load the IPv4/6 files - it'll conveniently throw an error if that fails. Yay!
  GeoIP *gi_4 = GeoIP_open("/usr/share/GeoIP/GeoIP.dat", GEOIP_MEMORY_CACHE);
  GeoIP *gi_6 = GeoIP_open("/usr/share/GeoIP/GeoIPv6.dat", GEOIP_MEMORY_CACHE);

  //Handle XFFS
  ip_addresses = xff_handler(ip_addresses);
  
  //Check input size, create output
  int input_size = ip_addresses.size();
  std::vector < std::string > output(input_size);
  
  //Holding object
  const char *returnedCountry;
  
  //For each IP...
  for(int i = 0; i < input_size; i++){
    
    //If it looks like an IPv4, run it through the IPv4 database
    if((signed int) ip_addresses[i].find(".") != -1){
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

  //Delete files to save space
  GeoIP_delete(gi_4);
  GeoIP_delete(gi_6);
  
  //Return
  return output;
}

//'@title geo_city
//'@details City-level geolocation
//'
//'@description
//'\code{geo_city} geolocates IPv4 and IPv6 addresses to provide city-level results, providing
//'the English-language name for that city. It uses
//'\href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database} - the only
//'limitation is that accuracy
//'\href{http://www.maxmind.com/en/city_accuracy}{varies on a per-country basis}.
//'
//'@param ips a vector of IP addresses. These will be processed through \code{xff_handler}
//'before being run, so don't worry if they're a bit groaty.
//'
//'@return a vector of city names. NULL or invalid responses from the API will be replaced with the string "Invalid".
//'
//'@author Oliver Keyes <okeyes@@wikimedia.org>
//'
//'@seealso \code{\link{geo_country}} for country-level identification, \code{\link{geo_tz}}
//'for tzdata-compatible timezone identification and \code{\link{geo_netspeed}} for connection
//'type detection.
//'@export
// [[Rcpp::export]]
std::vector < std::string > geo_city (std::vector < std::string > ip_addresses) {
  
  //Load the IPv4/6 files - it'll conveniently throw an error if that fails. Yay!
  GeoIP *gi_4 = GeoIP_open("/usr/share/GeoIP/GeoIPCity.dat", GEOIP_MEMORY_CACHE);
  GeoIP *gi_6 = GeoIP_open("/usr/share/GeoIP/GeoLiteCityv6.dat", GEOIP_MEMORY_CACHE);

  //Handle XFFS
  ip_addresses = xff_handler(ip_addresses);
  
  //Check input size, create output
  int input_size = ip_addresses.size();
  std::vector < std::string > output(input_size);
  
  //Holding objects
  GeoIPRecord *returned_record;
  char * city;

  //For each IP...
  for(int i = 0; i < input_size; i++){
    
    //If it looks like an IPv4, run it through the IPv4 database
    if(ip_addresses[i].find(".") >=0){
      returned_record = GeoIP_record_by_name(gi_4, string_to_const_pt(ip_addresses[i]));
    } else {
      //Otherwise, IPv6
      returned_record = GeoIP_record_by_name_v6(gi_6, string_to_const_pt(ip_addresses[i]));
    }
    
    //Either way, if it's NULL, save "Invalid", if it's not NULL...you get the picture.
    if(!returned_record){
      output[i] = "Invalid";
    } else {
      city = returned_record->city;
      if(!city){
        output[i] = "Invalid";
      } else {
        output[i] = const_pt_to_string(city);
      }
    }

  }
  
  //Delete files to save space
  GeoIP_delete(gi_4);
  GeoIP_delete(gi_6);
  
  //Return
  return output;
}

//'@title geo_region
//'@details Region-level geolocation
//'
//'@description
//'\code{geo_region} geolocates IPv4 and IPv6 addresses to provide region-level results, providing
//'the English-language name for that region (or a digit-based name in the case that administrative
//'districts in the pertinent nation do not have proper nouns). It uses
//'\href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database} - the only
//'limitation is that accuracy
//'\href{http://www.maxmind.com/en/city_accuracy}{varies on a per-country basis}.
//'
//'@param ips a vector of IP addresses. These will be processed through \code{xff_handler}
//'before being run, so don't worry if they're a bit groaty.
//'
//'@return a vector of region names. NULL or invalid responses from the API will be replaced with the string "Invalid".
//'
//'@author Oliver Keyes <okeyes@@wikimedia.org>
//'
//'@seealso \code{\link{geo_country}} for country-level identification, \code{\link{geo_city}} for city-level
//'geolocation, \code{\link{geo_tz}} for tzdata-compatible timezone identification and \code{\link{geo_netspeed}}
//'for connection type detection.
//'@export
// [[Rcpp::export]]
std::vector < std::string > geo_region (std::vector < std::string > ip_addresses) {
  
  //Load the IPv4/6 files - it'll conveniently throw an error if that fails. Yay!
  GeoIP *gi_4 = GeoIP_open("/usr/share/GeoIP/GeoIPCity.dat", GEOIP_MEMORY_CACHE);
  GeoIP *gi_6 = GeoIP_open("/usr/share/GeoIP/GeoLiteCityv6.dat", GEOIP_MEMORY_CACHE);
  
  //Handle XFFS
  ip_addresses = xff_handler(ip_addresses);
  
  //Check input size, create output
  int input_size = ip_addresses.size();
  std::vector < std::string > output(input_size);
  
  //Holding objects
  GeoIPRecord *returned_record;
  char * region;
  
  //For each IP...
  for(int i = 0; i < input_size; i++){
    
    //If it looks like an IPv4, run it through the IPv4 database
    if((signed int) ip_addresses[i].find(".") != -1){
      returned_record = GeoIP_record_by_name(gi_4, string_to_const_pt(ip_addresses[i]));
    } else {
      //Otherwise, IPv6, which we cannot 
      returned_record = GeoIP_record_by_name_v6(gi_6, string_to_const_pt(ip_addresses[i]));
    }
    
    if(!returned_record){
      output[i] = "Invalid";
    } else {
      region = returned_record->region;
      if(!region){
        output[i] = "Invalid";
      } else {
        output[i] = const_pt_to_string(region);
      }
    }
  }
  
  //Delete files to save space
  GeoIP_delete(gi_4);
  GeoIP_delete(gi_6);
  
  //Return
  return output;
}

//'@title geo_tz
//'@details tzdata-compatible timezone retrieval
//'
//'@description
//'\code{geo_tz} returns the timezone, in a tzdata-compliant format, associated with an IPv4 IP address.
//'This can then be used to (for example) localise server-side timestamps. It uses
//'\href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database} - the only
//'limitation is that accuracy
//'\href{http://www.maxmind.com/en/city_accuracy}{varies on a per-country basis}.
//'
//'@param ips a vector of IP addresses. These will be processed through \code{xff_handler}
//'before being run, so don't worry if they're a bit groaty.
//'
//'@return a vector of tzdata-compatible timezones. NULL or invalid responses from the API will be
//'replaced with the string "Invalid".
//'
//'@author Oliver Keyes <okeyes@@wikimedia.org>
//'
//'@seealso \code{\link{geo_country}} for country-level identification, \code{\link{geo_city}} for city-level
//'geolocation, \code{\link{geo_region}} for region-compatible timezone identification and \code{\link{geo_netspeed}}
//'for connection type detection.
//'@export
// [[Rcpp::export]]
std::vector < std::string > geo_tz (std::vector < std::string > ip_addresses) {
  
  //Load the IPv4/6 files - it'll conveniently throw an error if that fails. Yay!
  GeoIP *gi_4 = GeoIP_open("/usr/share/GeoIP/GeoIPCity.dat", GEOIP_MEMORY_CACHE);
  GeoIP *gi_6 = GeoIP_open("/usr/share/GeoIP/GeoLiteCityv6.dat", GEOIP_MEMORY_CACHE);
  
  //Handle XFFS
  ip_addresses = xff_handler(ip_addresses);
  
  //Check input size, create output
  int input_size = ip_addresses.size();
  std::vector < std::string > output(input_size);
  
  //Holding objects
  GeoIPRecord *returned_record;
  char * country_code;
  char * region;
  const char * holding;
  
  //For each IP...
  for(int i = 0; i < input_size; i++){
    
    //If it looks like an IPv4, run it through the IPv4 database
    if((signed int) ip_addresses[i].find(".") != -1){
      returned_record = GeoIP_record_by_name(gi_4, string_to_const_pt(ip_addresses[i]));
    } else {
      //Otherwise, IPv6, which we cannot 
      returned_record = GeoIP_record_by_name_v6(gi_6, string_to_const_pt(ip_addresses[i]));
    }
    
    if(!returned_record){
      output[i] = "Invalid";
    } else {
      
      region = returned_record->region;
      country_code = returned_record->country_code;
      if(!region | !country_code){
        output[i] = "Invalid";
      } else {
        holding = GeoIP_time_zone_by_country_and_region(country_code, region);
        
        if(!holding){
          output[i] = "Invalid";
        } else {
          output[i] = const_pt_to_string(holding);
        }
      }
    }
  }
  
  //Delete files to save space
  GeoIP_delete(gi_4);
  GeoIP_delete(gi_6);
  
  //Return
  return output;
}

//'@title c_geo_netspeed
//'@details tzdata-compatible timezone retrieval
//'
//'@description
//'\code{geo_netspeed} provides connection types for the provided IP address(es). It uses
//'\href{http://dev.maxmind.com/geoip/}{MaxMind's binary geolocation database} - the only
//'limitation is that accuracy
//'\href{http://www.maxmind.com/en/city_accuracy}{varies on a per-country basis}.
//'
//'@param ips a vector of IP addresses. These will be processed through \code{xff_handler}
//'before being run, so don't worry if they're a bit groaty.
//'
//'@return a vector of connection types. NULL or invalid responses from the API will be replaced with the
//'string "Unknown".
//'
//'@author Oliver Keyes <okeyes@@wikimedia.org>
//'
//'@seealso \code{\link{geo_country}} for country-level identification, \code{\link{geo_city}} for city-level
//'geolocation, \code{\link{geo_region}} for region-compatible timezone identification and \code{\link{geo_netspeed}}
//'for connection type detection.
//'@export
// [[Rcpp::export]]
std::vector < std::string > geo_netspeed (std::vector < std::string > ip_addresses) {
  
  //Load the Netspeed file (there's no real v6 handling here yet. Womp womp.)
  GeoIP *gi = GeoIP_open("/usr/share/GeoIP/GeoIPNetSpeedCell.dat", GEOIP_MEMORY_CACHE);
  
  //Handle XFFS
  ip_addresses = xff_handler(ip_addresses);
  
  //Check input size, create output
  int input_size = ip_addresses.size();
  std::vector < std::string > output(input_size);
  
  //Holding object
  char * speed;
  
  //For each IP...
  for(int i = 0; i < input_size; i++){
    
    //Run it through the db
    speed = GeoIP_name_by_name(gi, string_to_const_pt(ip_addresses[i]));
    
    if(!speed){
      output[i] = "Unknown";
    } else {
      output[i] = const_pt_to_string(speed);
    }
  }
  
  //Delete files to save space
  GeoIP_delete(gi);
  
  //Return
  return output;
}