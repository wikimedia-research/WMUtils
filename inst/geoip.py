import pygeoip
import sys
import json
import re

#List checking
def listcheck(x):
  
  if not(isinstance(x,list)):
    x = [x]
    
  return x
  

#Define country function
def country(x):
  
  #Read in files, storing in memory for speed
  ip4_geo = pygeoip.GeoIP(filename = sys.argv[4], flags = 1)
  ip6_geo = pygeoip.GeoIP(filename = sys.argv[5], flags = 1)
  
  #Check type
  x = listcheck(x)
  
  #Construct output list
  output_list = range(len(x))
    
  #For each entry in the input list, retrieve the country code and add it to the output object
  for i in range(len(x)):
  
    if(bool(re.search(":",x[i]))):
    
      output_list[i] = ip6_geo.country_code_by_addr(x[i])
      
    else:
      
      output_list[i] = ip4_geo.country_code_by_addr(x[i])
  
  #Return
  return output_list

#Define city function
def city(x):
  
  #Read in files, storing in memory for speed
  ip4_geo = pygeoip.GeoIP(filename = sys.argv[4], flags = 1)
  ip6_geo = pygeoip.GeoIP(filename = sys.argv[5], flags = 1)
  
  #Check type
  x = listcheck(x)
  
  #Construct output list
  output_list = range(len(x))
  
  #For each entry in the input list, retrieve the country code and add it to the output object
  for i in range(len(x)):
  
    if(bool(re.search(":",x[i]))):
    
      output_list[i] = ip6_geo.record_by_addr(x[i])
      
    else:
      
      output_list[i] = ip4_geo.record_by_addr(x[i])
  
  #Return
  return output_list

#Define city function
def tz_city(x):
  
  #Read in file, storing in memory for speed
  ip4_geo = pygeoip.GeoIP(filename = sys.argv[4], flags = 1)
  ip6_geo = pygeoip.GeoIP(filename = sys.argv[5], flags = 1)
  
  #Check type
  x = listcheck(x)
  
  #Construct output list
  output_list = range(len(x))
  
  #For each entry in the input list, retrieve the country code and add it to the output object
  for i in range(len(x)):
  
    if(bool(re.search(":",x[i]))):
    
      output_list[i] = ip6_geo.time_zone_by_addr(x[i])
      
    else:
      
      output_list[i] = ip4_geo.time_zone_by_addr(x[i])
  
  #Return
  return output_list

#Read in the file
json_data = open(sys.argv[1])
data = json.load(json_data, strict = False)
json_data.close()

#Check what's being asked for, and run the appropriate function
if(sys.argv[3] == "country"):
  
  output_data = country(x = data)
  
elif(sys.argv[3] == "city"):
  
  output_data = city(x = data)
  
elif(sys.argv[3] == "tz"):
  
  output_data = tz_city(x = data)

#Write out the results
file = open(sys.argv[2], 'w')
file.write(json.dumps(output_data))
file.close()
