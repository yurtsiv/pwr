from logic.Cases_world import Cases_world
from logic.Cases_country import Cases_country
from logic.Cases_day import Cases_day
from logic.Country_names import Country_names
from logic.const import COUNTRY_NAME_COLUMN, COUNTRY_CODE_COLUMN, CONTINENT_COLUMN, FILE_PATH, DATE_FORMAT


def parse_covid_file(file_path):
    cases_world = Cases_world()
    country_names = Country_names()

    with open(file_path, 'r') as csv_file:
        csv_file.readline()  # skip header

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

    return cases_world, country_names
