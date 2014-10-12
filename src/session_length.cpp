//Includes/namespaces
#include <Rcpp.h>
using namespace Rcpp;

//'@title
//'session_length
//'
//'@description
//'Session counting function
//' 
//'@param timestamps a vector of inter-time values.
//' 
//'@param local_minimum the threshold (in seconds) to split out a new session on. Set to 3600
//' by default.
//' 
//'@details
//'\code{session_length} takes a vector of intertime values (generated via \code{\link{intertimes}},
//'or in any other way you see fit), splits them into sessions, and calculates the approximate
//'length (in seconds) of each session. It's implemented in C++ since, even with the hinkiness
//'of my C++, it's still several OoM faster than the equivalent R (recursion in R is dumb).
//'
//'@section Warning:
//'Unlike \code{\link{intertime}} or \code{\link{session_count}}, the methodology here has not been
//'settled on; the internal workings of this function can and probably will change.
//'
//'@return a vector of session length counts, in seconds.
//' 
//'@seealso
//'\code{\link{intertimes}}, for generating inter-time values, and \code{\link{session_count}} for
//'simply counting the number of sessions.
//' 
//'@export
// [[Rcpp::export]]
NumericVector session_length(NumericVector intertimes, int local_minimum = 3600) {
  
  //Declare output object
  NumericVector output(1);
  
  //If there's only one element, this is easy
  if(intertimes.size() == 1){
    
    output[0] = 2 * intertimes[0];
    return output;
    
  }
  
  //Alternately, if we have >1 element, create holding objects
  int sum = 0;
  int vals_in_sum = 0;
  bool recurse_init = false;
  NumericVector recursed_output = 0;
  
  //Loop
  for(int i = 0; i < intertimes.size(); i++) {
    
    //If the value is less than the local minimum, include in the sum
    if(intertimes[i] < local_minimum){
      
      sum += intertimes[i];
      vals_in_sum ++;
      
    } else {
      
      //If the value is *greater* than the local minimum, recurse.
      recurse_init = true;
      recursed_output = session_length(intertimes = intertimes[seq(i, (intertimes.size()-1))],
                                       local_minimum = local_minimum);
      
      //When the recursed call completes, break
      break;
    }
    
  }
  
  //Whether we end up with one object or two objects, work out the time if appropriate
  if(vals_in_sum != 0){
    
    output[0] = (sum + (sum/vals_in_sum));
    
  }
  
  //If the recursed_output exists, pop on to that
  if(recurse_init){
    
    int recursed_size = recursed_output.size();
    NumericVector hold_vector(recursed_size+1);
    hold_vector[seq(0,(recursed_size - 1))] = recursed_output;
    hold_vector[recursed_size] = output[0];
    output = hold_vector;
    
  }
  
  //Return
  return output;
}