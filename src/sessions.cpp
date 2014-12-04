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
//' \code{\link{intertimes}}, for generating inter-time values,or \code{\link{session_length}} for
//' session length, in seconds.
//' 
//' @export
// [[Rcpp::export]]
int session_count(std::vector < int > x, int local_minimum = 3600) {
  
  //Note object length
  int length = x.size();
  
  //Create output object
  int count = 1;
  
  //Loop.
  for(int i = 0; i < length; i++) {
    
    //If the value is greater than the local minimum
    if(x[i] > local_minimum){
      
      //If the next value is not (or this is the last value)
      if(i+1 != length){
        if(x[i+1] <= local_minimum){
          //Increment
          count ++;
        }

      }

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
std::vector < int > session_length(std::vector < int > intertimes, int local_minimum = 3600, int average_intertime = 430) {
  
  //Declare output object
  std::vector < int > output;
  output.push_back(average_intertime);
  
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
      output.push_back(average_intertime);
      return output;
      
    }
    
  } else { //If we have multiple intertime periods, some work is in order.
    
    //Create holding objects
    int session_length = average_intertime;
    std::vector < int > output;
    
    //Loop. For each intertime value...
    for(int i = 0; i < intertimes.size(); i++) {
    
      //If the value is less than the local minimum, include in the sum
      if(intertimes[i] <= local_minimum){
      
        session_length += intertimes[i];
      
      } else {
      
        //If the value is greater, push_back the existing session_length value to output, then null it
        output.push_back(session_length);
        session_length = average_intertime;
        
      }
      
    }
    
    //Done? Cool. Except, still more work to be done.
    //If there is a stack still on session_length, or the last intertime > local_minimum, we need to add
    //to the stack
    if((session_length > average_intertime) | (intertimes[(intertimes.size() - 1)] >= local_minimum)){
      
      output.push_back(session_length);
      
    }
    
    //Return
    return output;
    
  }
  
}

//'@title session_pages
//'@description count the number of pages in a session (or multiple sessions)
//'
//'@details \code{session_pages} counts the number of pages in a session, or in multiple
//'sessions, based on a provided numeric vector of intertime values, which can be
//'generated via \code{\link{intertimes}}.
//'
//'@param intertimes a vector of intertime values.
//'
//'@param local_minimum the threshold at which to split a series of intertime values into
//'multiple sessions. Set to 3600 seconds (1 hour) by default.
//'
//'@seealso \code{\link{intertimes}} for generating intertime values, \code{\link{session_length}}
//'for session length, and \code{\link{session_count}} for the number of distinct sessions represented
//'by a series of intertime values.
//'
//'@export
// [[Rcpp::export]]
std::vector < int > session_pages(std::vector < int > intertimes, int local_minimum = 3600) {
  
  //Declare output object
  std::vector < int > output;

  //If there's only one intertime, this is easy - one session, which is two pages.
  if(intertimes.size() == 1){
    
    //Unless the intertime is >= the local_minimum, in which case we're looking at two one-page sessions.
    if(intertimes[0] >= local_minimum){
      
      output.push_back(1);
      output.push_back(1);
      
    } else {
      
      //Otherwise just rely on the existing "output"
      output.push_back(2);
      
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
        
        output.push_back(pages);
        pages = 1;
        
      }
      
    }
      
    output.push_back(pages);

  }
  
  return output;
  
}

//'@title intertimes
//'
//'@description calculate inter-time periods between timestamps
//'
//'@details
//'\code{\link{intertimes}} takes a set of timestamps and generates the interval between them, in seconds,
//'having sorted the timestamps from earliest to latest.
//'
//'@param timestamps a vector of second values. These can be extracted by converting
//'POSIXlt or POSIXct timestamps into numeric elements through a call to \code{\link{as.numeric}}.
//'
//'@seealso
//'\code{\link{session_count}}, which takes a set of intertime periods and work out how many sessions
//'they represent, \code{\link{session_length}}, which works out the approximate length
//'(in seconds) of each session, or \code{\link{session_pages}}, which works out how many pages
//'are represented (split into sessions) by a series of intertime values.
//'
//'@export
// [[Rcpp::export]]
std::vector < int > intertimes(std::vector < int > timestamps) {
  
  //Identify size of input object, create output
  int input_size = timestamps.size();
  std::vector < int > output;
  
  //If inpute size is 1, return -1
  if(input_size == 1){
    output.push_back(-1);
  } else {
    
    //Otherwise, sort input
    std::sort(timestamps.begin(),timestamps.end());
  
    //Loop over the data
    for(int i = 1; i < input_size;++i){
      
      //For each entry, the output value is [entry] minus [previous entry]
      output.push_back((timestamps[i] - timestamps[i-1]));
      
    }
    
  }
  
  //Return
  return output;
}