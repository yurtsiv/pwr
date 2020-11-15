import time

FILE_PATH = 'Covid.txt'

def calc_cases(file_name):
  with open(file_name, 'r') as covid_file:
    covid_file.readline() # skip header

    cases = 0
    for line in covid_file.readlines():
      row = line.split('\t')
      try:
        cases += int(row[4])
      except:
        pass
 
    return cases

try:
  print(calc_cases(FILE_PATH))
except:
  print('No Covid.txt file')