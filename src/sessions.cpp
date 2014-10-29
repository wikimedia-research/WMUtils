//Includes/namespaces
#include <Rcpp.h>
using namespace Rcpp;

//Generalised NumericVector expander
NumericVector numeric_vector_expander(NumericVector x, int to_insert) {
  
  //Calculate existing vector's size, create dummy output
  int existing_size = x.size();
  
  //If the existing vector's first value is zero, sod it, just return to_insert as a NumericVector
  if( (existing_size == 0) | ((existing_size == 1) & (x[0] == 0))){
    
    NumericVector holding_out(1);
    holding_out[0] = to_insert;
    return holding_out;
    
  } else {//Otherwise...
    
    //Create new vector, which is existing_size+1 in length
    NumericVector holding_out(existing_size+1);
    
    //Insert the existing values, then pop the new one on the end
    holding_out[seq(0,(existing_size-1))] = x;
    holding_out[existing_size] = to_insert;
    
    //Return
    return holding_out;
  }
  
}

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
//' \code{\link{intertimes}}, for generating inter-time values,or \code{\link{session_length}} for
//' session length, in seconds.
//' 
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

//'@title
//'session_length
//'
//'@description
//'Session counting function
//' 
//'@param intertimes a vector of inter-time values.
//' 
//'@param local_minimum the threshold (in seconds) to split out a new session on. Set to 3600
//' by default.
//'
//'@param average_intertime the average time between events within a session, used to handle missing values
//'(time associated with the first request in a series of intertime pairs, for example). Set to 430 seconds
//'by default.
//'
//'@details
//'\code{session_length} takes a vector of intertime values (generated via \code{\link{intertimes}},
//'or in any other way you see fit), splits them into sessions, and calculates the approximate
//'length (in seconds) of each session. It's implemented in C++ since, even with the hinkiness
//'of my C++, it's still several OoM faster than the equivalent R (recursion in R is dumb).
//'
//'@return a vector of session length counts, in seconds.
//' 
//'@seealso
//'\code{\link{intertimes}}, for generating inter-time values, and \code{\link{session_count}} for
//'simply counting the number of sessions.
//' 
//'@export
// [[Rcpp::export]]
NumericVector session_length(NumericVector intertimes, int local_minimum = 3600, int average_intertime = 430) {
  
  //Declare output object
  NumericVector output(1);
  output[0] = average_intertime;
  
  //If there's only one element...
  if(intertimes.size() == 1){
    
    //And it's below the local minimum...
    if(intertimes[0] <= local_minimum){
      
      //There's only one session, and it's intertimes + average_intertime long
      output[0] += intertimes[0];
      return output;
      
    } else {
      
      //If the value is greater than the local minimum, we have two sessions - and no way of extracting
      //the length of each. So, two sessions of average_intertime's duration.
      output = numeric_vector_expander(output, average_intertime);
      return output;
      
    }
    
  } else { //If we have multiple intertime periods, some work is in order.
    
    //Create holding objects
    int session_length = average_intertime;
    NumericVector output(1);
    
    //Loop. For each intertime value...
    for(int i = 0; i < intertimes.size(); i++) {
    
      //If the value is less than the local minimum, include in the sum
      if(intertimes[i] <= local_minimum){
      
        session_length += intertimes[i];
      
      } else {
      
        //If the value is greater, append the existing session_length value to output, then null it
        output = numeric_vector_expander(output, session_length);
        session_length = average_intertime;
        
      }
      
    }
    
    //Done? Cool. Except, still more work to be done.
    //If there is a stack still on session_length, or the last intertime > local_minimum, we need to add
    //to the stack
    if((session_length > average_intertime) | (intertimes[(intertimes.size() - 1)] >= local_minimum)){
      
      output = numeric_vector_expander(output, session_length);
      
    }
    
    //Return
    return output;
    
  }
  
}

// [[Rcpp::export]]
NumericVector session_pages(NumericVector intertimes, int local_minimum = 3600) {
  
  //Declare output object
  NumericVector output(1);
  
  //If there's only one intertime, this is easy - one session, which is two pages.
  if(intertimes.size() == 1){
    
    //Unless the intertime is >= the local_minimum, in which case we're looking at two one-page sessions.
    if(intertimes[0] >= local_minimum){
      
      //Create holding object, assign values to it, replace output
      NumericVector hold(2);
      hold[0] = 1;
      hold[1] = 1;
      output = hold;
      
    } else {
      
      //Otherwise just rely on the existing "output"
      output[0] = 2;
      
    }

  //If there are multiple intertimes we actually need to loop through.
  } else {
    
    //Create the actual page counter. This starts at 1, because intertimes are 2 events, only 1 captured for intertimes[0]
    int pages = 1; 
    
    //Loop
    for(int i = 0; i < intertimes.size(); i++) {
      
      //If the value is below the local minimum, increment
      if(intertimes[i] < local_minimum){
        
        pages ++;
        
      //Otherwise, pop pages on output and create a new entry
      } else {
        
        output = numeric_vector_expander(output, pages);
        pages = 1;
        
      }
      
    }
    
    //If there has been a value > intertime_period, we need to pop things on again right at the end.
    if((output.size() > 1) | (output[0] > 1)){
      
      output = numeric_vector_expander(output, pages);
        
    } else {
      
      //Otherwise just add the pagecount for the "first" session.
      output[0] = pages;
      
    }
  }
  
  return output;
  
}

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