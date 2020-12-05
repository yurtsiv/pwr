from logic.const import FILE_PATH
from logic.parse import parse_covid_file
from operator import attrgetter

def parse_data():
    return parse_covid_file(FILE_PATH)

def transform_data(cases_world, country_names, country_code=None, continent=None, date_range=None, sort_by_key=None, rows_limit=None):
    result = []

    for cases_country in cases_world.all_cases_countries:
        result += cases_country.rows

    if country_code is not None:
        result = cases_world.get_cases_country(country_code).rows

    if continent is not None:
        continent_countries = country_names.countries_in_continents[continent]

        result = []
        for country in continent_countries:
            result += cases_world.get_cases_country(country).rows

    if date_range is not None:
        (date_from, date_to) = date_range

        def predicate(row):
            if date_from and date_to:
                return date_from <= row["day"] <= date_to
            elif date_from:
                return row["day"] >= date_from
            elif date_to:
                return row["day"] <= date_to
            else:
                return True
 
        result = list(filter(
            predicate,
            result
        ))

    if sort_by_key is not None:
        result.sort(key=lambda row: row[sort_by_key], reverse=True)

    if rows_limit is not None:
        result = result[:rows_limit]

    return result
