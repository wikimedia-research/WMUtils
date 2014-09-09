from ua_parser import user_agent_parser as uap
import csv
import argparse

#Set up argparse
parser = argparse.ArgumentParser(description="user agent geolocation")
parser.add_argument("-i", type = str, help = "The input JSON file", required = True, dest = "input")
parser.add_argument("-o", type = str, help = "The output JSON file", required = True, dest = "output")
args = parser.parse_args()

#Create object to iterate over
ua_list = []

#Open connection
file_con = open(name = args.input, mode = "r")
tsv_reader = csv.reader(file_con, delimiter="\t")

#Read in, handling invalid rows as we go
for line in tsv_reader:
  try:
    ua_list.append(line[0])
  except:
    ua_list.append("")

#Close
file_con.close()

#Construct output list
output_list = []

#For each entry in the input list, 
for entry in ua_list:
    
    #Retrieve the UA results
    UA_results = uap.Parse(entry)
    UA_results = {'device': UA_results['device']['family'],'os': UA_results['os']['family'], 'browser': UA_results['user_agent']['family'], 'browser_major': UA_results['user_agent']['major'], 'browser_minor': UA_results['user_agent']['minor']}
    
    #Limit to things we care about
    output_list.append(UA_results.values())


#Write out
output_file = open(name = args.output, mode = "w")
tsv_writer = csv.writer(output_file, delimiter="\t")
tsv_writer.writerows(output_list)
output_file.close()
