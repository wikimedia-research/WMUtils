#include <openssl/sha.h>
#include <Rcpp.h>
using namespace Rcpp;

namespace cryptohash {
  
  std::string SHA256_string(std::string x){
    
    //Create hash. SHA256 hashes are 256 bits, or 32 bytes.
    unsigned char hash[32];
    
    //Turn X into a const char*
    char* holding = new char [x.length()+1];
    strcpy (holding, x.c_str());
    const char* x_const = holding;
    
    //Initialise SHA256 holding object
    SHA256_CTX ctx;
    SHA256_Init(&ctx);
    SHA256_Update(&ctx, x_const, strlen(x_const));
    SHA256_Final(hash, &ctx);
  
    char shastring[65];
    for (int i = 0; i < 32; i++){
      sprintf(&shastring[i*2], "%02x", (unsigned int) hash[i]);
    }
    std::string output = shastring;
    return output;
    
  }
  
  std::vector < std::string > SHA256_vector(std::vector < std::string > x_vec){
    
    //Calculate vector length and create an output object
    int input_length = x_vec.size();  
    std::vector < std::string > output(input_length);
  
    //For each string, SHA256 and return the resulting vector.
    for(int i = 0; i < input_length; i++) {
      output[i] = SHA256_string(x_vec[i]);
    }
    return output;
  }
  
}