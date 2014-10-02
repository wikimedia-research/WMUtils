#Imports
import pygeoip
import re  
import argparse
import io_defs

#Set up argparse
parser = argparse.ArgumentParser(description="Country-level geolocation")
parser.add_argument("-i", type = str, help = "The input text file", required = True, dest = "input")
parser.add_argument("-o", type = str, help = "The output text file", required = True, dest = "output")
args = parser.parse_args()

#Read in MaxMind binary files, storing in memory for speed
ip4_geo = pygeoip.GeoIP(filename = "/usr/share/GeoIP/GeoIP.dat", flags = 1)
ip6_geo = pygeoip.GeoIP(filename = "/usr/share/GeoIP/GeoIPv6.dat", flags = 1)

#Read in input
ip_list = io_defs.generic_input(name = args.input)

#Create output list
output = []

#For each entry, retrieve the country code and replace
for entry in ip_list:
  
  #If it's IPV6, use the 6 method
  if(re.search(":",entry)):
    
    try:
      output.append(str(ip6_geo.country_code_by_addr(entry)+"\n"))
    except:
      output.append("Invalid\n")
  
  #4, use 4.
  else:
    
    try:
      output.append(str(ip4_geo.country_code_by_addr(entry)+"\n"))
    except:
      output.append("Invalid\n")

#Write out
io_defs.generic_output(name = args.output, x = output)
