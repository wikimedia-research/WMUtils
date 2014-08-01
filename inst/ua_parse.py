from ua_parser import user_agent_parser as uap
import json
import argparse

#Set up argparse
parser = argparse.ArgumentParser(description="user agent geolocation")
parser.add_argument("-i", type = str, help = "The input JSON file", required = True, dest = "input")
parser.add_argument("-o", type = str, help = "The output JSON file", required = True, dest = "output")
args = parser.parse_args()

#Function for parsing incoming lists of UAs and throwing them into another list
def parse_ua(x):
    
    #Check type
    if not(isinstance(x,list)):
        x = [x]
        
    #Construct output list
    output_list = []
    
    #For each entry in the input list, 
    for entry in x:
        
        #Retrieve the UA results
        UA_results = uap.Parse(entry)
        
        #Limit to things we care about
        output_list.append({'device': UA_results['device']['family'],'os': UA_results['os']['family'], 'browser': UA_results['user_agent']['family'], 'browser_major': UA_results['user_agent']['major'], 'browser_minor': UA_results['user_agent']['minor']})
    
    #And return
    return output_list

#Import object
json_data = open(args.input)
data = json.load(json_data, strict = False)
json_data.close()

#Parse it and convert it back
parsed_data = json.dumps(parse_ua(data))

#Write it
file = open(args.output, 'w')
file.write(parsed_data)
file.close()
