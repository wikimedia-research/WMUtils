#include <Rcpp.h>
using namespace Rcpp;

//'@title extract_mcc
//'@description extract a mobile carrier code (mcc) from an x_analytics header
//'@details \code{\link{extract_mcc}} grabs a mobile carrier code and associated country code
//'from an x_analytics field, where such a code is present (i.e., requests from Zero)
//'
//'@param x_analytics a vector of x_analytics fields
//'
//'@return a vector of empty strings or MCC codes, depending on if an MCC was found.
//'
//'@export
// [[Rcpp::export]]
std::vector < std::string > extract_mcc(std::vector < std::string > x_analytics) {
   
  //Measure size, construct output/intermediaries
  int input_length = x_analytics.size();
  std::vector < std::string > output(input_length);
  std::string holding;
  
  //For each x_analytics field..
  for(int i = 0; i < input_length; i++) {
    
    //Grab the zero location and, if it's present..
    std::size_t zero_loc = x_analytics[i].find("zero=");
    if((signed int) zero_loc != -1){
      
      //Substring to it
      holding = x_analytics[i].substr(zero_loc+5,7);
      
      //If this includes a semicolon (it might! Some MCCs are length-6, some are length-7) remove.
      if((signed int) holding.find(";") != -1){
        output[i] = holding.substr(0,6);
      } else {
        output[i] = holding;
      }
    }
  }
  
  return output;
}
