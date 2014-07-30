#Imports
import pygeoip
import json
import re  
import argparse

#Set up argparse
parser = argparse.ArgumentParser(description="Country-level geolocation")
parser.add_argument("-i", type = str, help = "The input JSON file", required = True, dest = "input")
parser.add_argument("-o", type = str, help = "The output JSON file", required = True, dest = "output")
args = parser.parse_args()

#Define country function
def country(x):
  
  #Read in files, storing in memory for speed
  ip4_geo = pygeoip.GeoIP(filename = "/usr/share/GeoIP/GeoIP.dat", flags = 1)
  ip6_geo = pygeoip.GeoIP(filename = "/usr/share/GeoIP/GeoIPv6.dat", flags = 1)
  
  #Check type
  if not(isinstance(x,list)):
    x = [x]
  
  #Construct output list
  output = []
    
  #For each entry in the input list, retrieve the country code and add it to the output object
  for entry in x:
  
    if(bool(re.search(":",entry))):
      
      try:
        
        output.append(ip6_geo.country_code_by_addr(entry))
        
      except:
        
        output.append("Invalid")
        
    else:
      
      try:
        
        output.append(ip4_geo.country_code_by_addr(entry))
        
      except:
        
        output.append("Invalid")
  
  #Return
  return output

#Read in the file
json_data = open(args.input)
data = json.load(json_data, strict = False)
json_data.close()

#Run
output_data = country(x = data)

#Write out the results
file = open(args.output, 'w')
file.write(json.dumps(output_data))
file.close()
