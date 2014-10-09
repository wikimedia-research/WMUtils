#include <Rcpp.h>
#include <vector>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector cpp_intertimes(NumericVector timestamps) {
  
  //Identify size of input object
  int input_size = timestamps.size();
  
  //Instantiate output object
  NumericVector output(input_size-1);
  
  //Sort input
  std::sort(timestamps.begin(),timestamps.end());
  
  //Loop over the data
  for(int i = 1; i < input_size;++i){
    
    //For each entry, the output value is [entry] minus [previous entry]
    output[i-1] = (timestamps[i] - timestamps[i-1]);
    
  }
  
  //Return
  return output;
}