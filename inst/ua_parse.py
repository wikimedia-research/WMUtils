from ua_parser import user_agent_parser as uap
import json
import sys

#Function for parsing incoming lists of UAs and throwing them into another list
def parse_ua(x):
    
    #Check type
    if(isinstance(x,list)):
        obj_length = len(x)
    else:
        obj_length = 1
        
    #Construct output list, same length as the input list
    output_list = range(obj_length)
    
    #For each entry in the input list, 
    for i in range(obj_length):
        
        #Retrieve the UA results
        UA_results = uap.Parse(x[i])
        
        #Limit to things we care about
        output_list[i] = {'device': UA_results['device']['family'],'os': UA_results['os']['family'], 'browser': UA_results['user_agent']['family'], 'browser_major': UA_results['user_agent']['major'], 'browser_minor': UA_results['user_agent']['minor']}
    
    #And return
    return output_list

#Import object
json_data = open(sys.argv[1])
data = json.load(json_data, strict = False)
json_data.close()

#Parse it and convert it back
parsed_data = json.dumps(parse_ua(data))

#Write it
file = open(sys.argv[2], 'w')
file.write(parsed_data)
file.close()
