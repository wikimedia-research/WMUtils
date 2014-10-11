#A generic input function, used by geo_* scripts. It happily handles .txts.
def generic_input(name):
  
  #Create object
  output_list = []
  
  #Open connection
  file_con = open(name = name, mode = "r")
  
  #Read in, handling invalid rows as we go
  for line in file_con:
    try:
      output_list.append(line)
    except:
      output_list.append("")
  
  #Close
  file_con.close()
  
  #Return
  return output_list

#A generic output function - same as above, on all fronts.
def generic_output(name, x):
  
  #Open, write, close
  output_file = open(name = name, mode = "w")
  output_file.writelines(x)
  output_file.close()
  
