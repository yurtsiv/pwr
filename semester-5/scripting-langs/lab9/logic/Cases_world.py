from logic.Cases_country import Cases_country
from logic.Cases_day import Cases_day


class Cases_world:
    '''
    Holds all cases/deaths for each country in the world
    '''
    def __init__(self):
        # Structure
        # { "PL": Cases_country(...) }
        self.__countries = {}

    def add_cases_country(self, cases_country):
        self.__countries[cases_country.country_code] = cases_country

    def get_cases_country(self, country_code):
        return self.__countries.get(country_code)

    def get_countries(self):
        return list(self.__countries.values())
