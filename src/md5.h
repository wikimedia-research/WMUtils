//Includes
#include <openssl/md5.h>
#include <Rcpp.h>
using namespace Rcpp;

namespace cryptohash {
    
  std::string MD5_string(std::string x){
  
    //Create hash. MD5 hashes are 128 bits, or 16 bytes.
    unsigned char hash[16];
    
    //Turn X into a const char*
    char* holding = new char [x.length()+1];
    strcpy (holding, x.c_str());
    const char* x_const = holding;
    
    //Initialise MD5 holding object
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, x_const, strlen(x_const));
    MD5_Final(hash, &ctx);
  
    char mdString[33];
    for (int i = 0; i < 16; i++){
      sprintf(&mdString[i*2], "%02x", (unsigned int) hash[i]);
    }
    std::string output = mdString;
    return output;
  }
  
  std::vector < std::string > MD5_vector(std::vector < std::string > x_vec){
    
    //Calculate vector length and create an output object
    int input_length = x_vec.size();  
    std::vector < std::string > output(input_length);
  
    //For each string, MD5 and return the resulting vector.
    for(int i = 0; i < input_length; i++) {
      output[i] = MD5_string(x_vec[i]);
    }
    return output;
  }
  
}