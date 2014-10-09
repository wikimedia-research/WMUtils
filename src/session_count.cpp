//Includes/namespaces
#include <Rcpp.h>
using namespace Rcpp;

//' @title
//' session_count
//' @description
//' Session counting function
//' 
//' @param x a vector of intertime values
//' 
//' @param local_minimum the threshold (in seconds) to split out a new session on. Set to 3600
//' by default.
//' 
//' @details
//' \code{session_count} takes a vector of intertime values (generated via \code{\link{intertimes}},
//' or in any other way you see fit) and returns the total number of sessions within that dataset.
//' It's implimented in C++, providing a (small) increase in speed over the R equivalent.
//' 
//' @seealso
//' \code{\link{intertimes}}, for generating inter-time values.
//' @export
// [[Rcpp::export]]
int session_count(NumericVector x, int local_minimum = 3600) {
  
  //Create output object
  int count = 1;
  
  //Loop.
  for(int i = 0; i < x.size(); i++) {
    
    //If the value is greater than the local minimum, increment the count
    if(x[i] > local_minimum){
      count ++;
    }
    
  }
  
  //Return
  return count;
}
