import time

FILE_PATH = 'Covid.txt'

def calc_cases(file_name, country):
    with open(file_name, 'r') as covid_file:
        covid_file.readline() # skip header

        cases = 0
        for line in covid_file.readlines():
            row = line.split('\t')
            if row[6] == country:
                try:
                    cases += int(row[4])
                except:
                    pass

        return cases

country = input("Country: ")

try:
    print(calc_cases(FILE_PATH, country))
except:
    print('No Covid.txt file')