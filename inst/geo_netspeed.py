#Imports
import pygeoip
import argparse
import io_defs

#Set up argparse
parser = argparse.ArgumentParser(description="Connection type detection")
parser.add_argument("-i", type = str, help = "The input text file", required = True, dest = "input")
parser.add_argument("-o", type = str, help = "The output text file", required = True, dest = "output")
args = parser.parse_args()

#Read in MaxMind binary files, storing in memory for speed
netspeed_db = pygeoip.GeoIP(filename = "/usr/share/GeoIP/GeoIPNetSpeedCell.dat", flags = 1)

#Read in input
ip_list = io_defs.generic_input(name = args.input)

#Create output list
output = []

#For each entry, retrieve the country code and replace
for entry in ip_list:
    
  try:
    output.append(str(netspeed_db.netspeed_by_addr(entry)+"\n"))
  except:
    output.append("Invalid\n")

#Write out
io_defs.generic_output(name = args.output, x = output)
