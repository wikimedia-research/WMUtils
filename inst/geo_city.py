#Imports
import pygeoip
import re  
import argparse

#Set up argparse
parser = argparse.ArgumentParser(description="City-level geolocation")
parser.add_argument("-i", type = str, help = "The input text file", required = True, dest = "input")
parser.add_argument("-o", type = str, help = "The output text file", required = True, dest = "output")
args = parser.parse_args()

#Read in MaxMind binary files, storing in memory for speed
ip4_geo = pygeoip.GeoIP(filename = "/usr/share/GeoIP/GeoIPCity.dat", flags = 1)
ip6_geo = pygeoip.GeoIP(filename = "/usr/share/GeoIP/GeoLiteCityv6.dat", flags = 1)

#Create object to iterate over
ip_list = []

#Open connection
file_con = open(name = args.input, mode = "r")

#Read in, handling invalid rows as we go
for line in file_con:
  try:
    ip_list.append(line)
  except:
    ip_list.append("")

#Close
file_con.close()

#Create output list
output = []

#For each entry, retrieve the country code and replace
for entry in ip_list:
  
  #If it's IPV6, use the 6 method
  if(bool(re.search(":",entry))):
    
    try:
      output.append(ip6_geo.record_by_addr(entry)['city']+"\n")
    except:
      output.append("Invalid\n")
  
  #4, use 4.
  else:
    
    try:
      output.append(ip4_geo.record_by_addr(entry)['city']+"\n")
    except:
      output.append("Invalid\n")

#Write out
output_file = open(name = args.output, mode = "w")
output_file.writelines(output)
output_file.close()
