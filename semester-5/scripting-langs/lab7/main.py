from Cases_world import Cases_world
from Cases_country import Cases_country
from Cases_day import Cases_day
from Country_names import Country_names
from const import COUNTRY_NAME_COLUMN, COUNTRY_CODE_COLUMN, CONTINENT_COLUMN, FILE_PATH, DATE_FORMAT
from utils import flatten_list
from itertools import groupby

cases_world = Cases_world()
country_names = Country_names()

# Populate cases_world & country_names
with open(FILE_PATH, 'r') as csv_file:
  csv_file.readline() # skip header

  for row in csv_file.readlines():
    cases_day = Cases_day.from_row(row)
    columns = row.split('\t')
    country_name = columns[COUNTRY_NAME_COLUMN]
    country_code = columns[COUNTRY_CODE_COLUMN]
    continent = columns[CONTINENT_COLUMN]
    cases_country = cases_world.get_cases_country(country_code)

    country_names.add_country(country_code, country_name, continent)

    if cases_country is None:
      cases_world.add_cases_country(
        Cases_country(country_code, [cases_day])
      )
    else:
      cases_country.add_cases_day(cases_day)

cases_countries = cases_world.get_countries()

# Most deaths
most_deaths_country = max(cases_countries, key=lambda c: c.total_deaths)
most_deaths_country_name = country_names.get_name_by_code(most_deaths_country.country_code)
print("Most deaths: " + most_deaths_country_name)

# Most cases
most_cases_country = max(cases_countries)
most_cases_country_name = country_names.get_name_by_code(most_cases_country.country_code)
print("\nMost cases: " + most_cases_country_name)

def get_worst_day(cases_days):
  cases_days.sort(key=lambda day: day.day)
  worst_day_date = all_days[0].day
  worst_day_deaths = all_days[0].deaths

  for day, cases_for_date in groupby(cases_days, key=lambda day: day.day):
    deaths = sum(map(lambda day: day.deaths, list(cases_for_date)))

    if deaths > worst_day_deaths:
      worst_day_date = day
      worst_day_deaths = deaths
  
  return (worst_day_date, worst_day_deaths)


# Worst day in the world
all_days = flatten_list(
  map(lambda country: country.all_days, cases_countries)
)

(worst_day_date, worst_day_deaths) = get_worst_day(all_days)

print("\nWorst day in the world: %s  %d deaths" % (worst_day_date.strftime(DATE_FORMAT), worst_day_deaths))

# Worst day for each continent
print("\n-- Worst days for each continent --\n")
countries_in_continents = country_names.countries_in_continents
for continent in countries_in_continents.keys():
  continent_cases_countries = map(
    lambda code: cases_world.get_cases_country(code),
    countries_in_continents[continent]
  )

  continent_all_days = flatten_list(
    map(lambda country: country.all_days, continent_cases_countries)
  )

  (continent_worst_day_date, continent_worst_day_deaths) = get_worst_day(continent_all_days)

  print("\nWorst day for %s: %s  %d deaths" % (
    continent,
    continent_worst_day_date.strftime(DATE_FORMAT),
    continent_worst_day_deaths
  ))

# Worst day for each country
print("\n-- Worst days for each country --\n")
for cases_country in cases_countries:
  worst_day = max(cases_country.all_days, key=lambda day: day.deaths)
  country_name = country_names.get_name_by_code(cases_country.country_code)

  if country_name is not None:
    print("Worst day for " + country_name + ": " + str(worst_day)) 
