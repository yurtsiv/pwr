from logic.const import FILE_PATH
from logic.parse import parse_covid_file

print('Please wait, parsing the file...')
cases_world, country_names = parse_covid_file(FILE_PATH)
print('Parsing complete, enter your command')

def test():
    pass