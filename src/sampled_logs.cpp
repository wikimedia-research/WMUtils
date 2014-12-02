#include <Rcpp.h>
#include <iostream>
#include <fstream>

using namespace Rcpp;

struct requests {
  
  std::vector < std::string > timestamp;
  std::vector < std::string > ip_address;
  std::vector < std::string > status_code;
  std::vector < std::string > URL;
  std::vector < std::string > mime_type;
  std::vector < std::string > referer;
  std::vector < std::string > x_forwarded;
  std::vector < std::string > user_agent;
  std::vector < std::string > lang;
  std::vector < std::string > x_analytics;
  
};

std::vector < std::string > extract_fields(std::string fileline){
  
  //Construct a vector of the fields we want, and of the split results (and output)
  std::vector < int > wanted_fields = {2,4,5,8,10,11,12,13,14,15};
  std::vector < std::string > output;
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
DataFrame c_sampled_logs(const char* filename){
  
  //Temp objects
  std::string holding;
  std::vector < std::string > filter_output;
  requests request_hold;
  
  //Open connector and check
  std::ifstream con(filename, std::ios_base::in | std::ios_base::binary);
  if(!con){
    throw std::range_error("File could not be opened.");
  }
  
  //Assuming it didn't error out, loop through reading and removing fields we don't care about
  while(!con.eof()){
    
    getline(con, holding);
    if(!holding.empty()){
      filter_output = extract_fields(holding);
      request_hold.timestamp.push_back(filter_output[0]);
      request_hold.ip_address.push_back(filter_output[1]);
      request_hold.status_code.push_back(filter_output[2]);
      request_hold.URL.push_back(filter_output[3]);
      request_hold.mime_type.push_back(filter_output[4]);
      request_hold.referer.push_back(filter_output[5]);
      request_hold.x_forwarded.push_back(filter_output[6]);
      request_hold.user_agent.push_back(filter_output[7]);
      request_hold.lang.push_back(filter_output[8]);
      request_hold.x_analytics.push_back(filter_output[9]);
    }
  }
  
  return DataFrame::create(_["timestamp"] = request_hold.timestamp, _["ip_address"] = request_hold.ip_address, _["status_code"] = request_hold.status_code,
                         _["URL"] = request_hold.URL, _["mime_type"] = request_hold.mime_type, _["referer"] = request_hold.referer,
                         _["x_forwarded"] = request_hold.x_forwarded, _["user_agent"] = request_hold.user_agent, _["lang"] = request_hold.lang,
                         _["x_analytics"] = request_hold.x_analytics,
                         _["stringsAsFactors"] = false);
  
}