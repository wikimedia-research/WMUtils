#include <Rcpp.h>
#include "internal_ua_parser.h"
using namespace Rcpp;

// Internal C function for parsing user agents.
// [[Rcpp::export]]
DataFrame c_ua_parse(std::vector < std::string > agents, std::string regex_file) {
  
  //Load regex file
  ua_parser::Parser uap(regex_file);
  
  //Measure input size, create output objects
  int agents_size = agents.size();
  std::vector < std::string > device_family(agents_size);
  std::vector < std::string > os(agents_size);
  std::vector < std::string > browser_family(agents_size);
  std::vector < std::string > browser_major(agents_size);
  std::vector < std::string > browser_minor(agents_size);
  
  //For each agent...
  for(int i = 0; i < agents_size; i++) {
    
    //Identify it
    ua_parser::UserAgent holding = uap.Parse(agents[i]);
    
    //Throw the results into the relevant vectors
    device_family[i] = holding.device;
    os[i] = holding.os.os;
    browser_family[i] = holding.browser.family;
    browser_major[i] = holding.browser.major;
    browser_minor[i] = holding.browser.minor;
    
  }
  
  //Create DF out of the resulting objects and return it
  return DataFrame::create(_["device"] = device_family, _["os"] = os, _["browser"] = browser_family,
                           _["major_version"] = browser_major, _["minor_version"] = browser_minor,
                           _["stringsAsFactors"] = false);
  
}
