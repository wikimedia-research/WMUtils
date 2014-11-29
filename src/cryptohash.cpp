#include <Rcpp.h>
#include "cryptohash.h"
using namespace Rcpp;
using namespace cryptohash;

// [[Rcpp::export]]
std::vector < std::string > c_cryptohash(std::vector < std::string > x, std::string algorithm) {
  
  //Check input
  if(x.size() == 0){
    throw std::range_error("The vector you have provided is empty.");
  }
  
  //Create output
  std::vector < std::string > output;
    
  //Check algorithm
  if(algorithm == "md5"){
    output = cryptohash::MD5_vector(x);
  } else if(algorithm == "sha1"){
    output = cryptohash::SHA1_vector(x);
  } else if(algorithm == "sha256"){
    output = cryptohash::SHA256_vector(x);
  } else if(algorithm == "sha512"){
    output = cryptohash::SHA512_vector(x);
  } else {
    throw std::range_error("You did not provide a valid algorithm");
  }
  
  //Return
  return output;
}
