#include <openssl/sha.h>
#include <Rcpp.h>
using namespace Rcpp;

namespace cryptohash {
  
  std::string SHA512_string(std::string x){
    
    //Create hash. SHA512 hashes are 512 bits, or 64 bytes.
    unsigned char hash[64];
    
    //Turn X into a const char*
    char* holding = new char [x.length()+1];
    strcpy (holding, x.c_str());
    const char* x_const = holding;
    
    //Initialise MD5 holding object
    SHA512_CTX ctx;
    SHA512_Init(&ctx);
    SHA512_Update(&ctx, x_const, strlen(x_const));
    SHA512_Final(hash, &ctx);
  
    char shastring[129];
    for (int i = 0; i < 64; i++){
      sprintf(&shastring[i*2], "%02x", (unsigned int) hash[i]);
    }
    std::string output = shastring;
    return output;
    
  }
  
  std::vector < std::string > SHA512_vector(std::vector < std::string > x_vec){
    
    //Calculate vector length and create an output object
    int input_length = x_vec.size();  
    std::vector < std::string > output(input_length);
  
    //For each string, SHA512 and return the resulting vector.
    for(int i = 0; i < input_length; i++) {
      output[i] = SHA512_string(x_vec[i]);
    }
    return output;
  }
  
}