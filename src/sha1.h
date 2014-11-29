#include <openssl/sha.h>
#include <Rcpp.h>
using namespace Rcpp;

namespace cryptohash {
  
  std::string SHA1_string(std::string x){
    
    //Create hash. SHA1 hashes are 160 bits, or 20 bytes.
    unsigned char hash[20];
    
    //Turn X into a const char*
    char* holding = new char [x.length()+1];
    strcpy (holding, x.c_str());
    const char* x_const = holding;
    
    //Initialise SHA1 holding object
    SHA_CTX ctx;
    SHA1_Init(&ctx);
    SHA1_Update(&ctx, x_const, strlen(x_const));
    SHA1_Final(hash, &ctx);
  
    char shastring[41];
    for (int i = 0; i < 20; i++){
      sprintf(&shastring[i*2], "%02x", (unsigned int) hash[i]);
    }
    std::string output = shastring;
    return output;
    
  }
  
  std::vector < std::string > SHA1_vector(std::vector < std::string > x_vec){
    
    //Calculate vector length and create an output object
    int input_length = x_vec.size();  
    std::vector < std::string > output(input_length);
  
    //For each string, SHA1 and return the resulting vector.
    for(int i = 0; i < input_length; i++) {
      output[i] = SHA1_string(x_vec[i]);
    }
    return output;
  }
  
}