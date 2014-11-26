#include <Rcpp.h>
#include <fstream>
#include <iostream>
using namespace Rcpp;

std::list < std::string > extract_fields(std::string fileline){
  
  //Construct a vector of the fields we want, and of the split results (and output)
  std::vector < int > wanted_fields = {2,4,5,8,10,11,12,13,14,15};
  std::list < std::string > output;
  int indices = 0;

  //Until the string is empty...
  while(indices <= 15){
    
    //Find a tab
    std::size_t tab = fileline.find("\t"); 
    
    //If you can't, end.
    if((signed int) tab == -1){
      output.push_back(fileline);
      break;
    }
    
    //If it's in wanted_fields, write to output
    if(std::find(wanted_fields.begin(), wanted_fields.end(), indices) != wanted_fields.end()){
      output.push_back(fileline.substr(0,tab));

    }
    
    //Increment
    indices += 1;
    
    //Substring fileline
    fileline = fileline.substr(tab+1);
  }
  
  //Handle the possibility that it failed to find some fields
  while(output.size() < 10){
    output.push_back("");
  }
  
  return output;
}

// [[Rcpp::export]]
std::list < std::list < std::string > > c_sampled_logs(const char* filename){
  
  //Temp objects
  std::string holding;
  std::list < std::list < std::string > > output;
  
  //Open connector and check
  std::ifstream con(filename);
  if(!con){
    throw std::range_error("File could not be opened.");
  }
  
  //Assuming it didn't error out, loop through reading and removing fields we don't care about
  while(!con.eof()){
    
    getline(con, holding);
    if(!holding.empty()){
      output.push_back(extract_fields(holding));
    }
  }
  
  //Return
  return(output);
}