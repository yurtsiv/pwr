from logic.utils import calc_edit_distance
from operator import itemgetter


class Country_names:
    '''
    Holds unique country codes with the
    corresponding country name and continent
    '''

    def __init__(self):
        # Structure
        # { "PL": { "name": "Poland", "continent": "Europe" } }
        self.__countries = {}

    def add_country(self, code, name, continent):
        if self.__countries.get(code) is not None:
            return

        self.__countries[code] = {"name": name, "continent": continent}


    def get_name_by_code(self, code):
        country = self.__countries.get(code)

        if country is None:
            return None

        return country["name"]

    def get_code_by_name(self, name):
        for code in self.__countries.keys():
            if self.__countries[code]["name"] == name:
                return code

    @property
    def countries_in_continents(self):
        result = {}

        for code in self.__countries:
            continent = self.__countries[code]["continent"]

            if result.get(continent) is None:
                result[continent] = [code]
            else:
                result[continent].append(code)

        return result

    @property
    def continents(self):
        return list(self.countries_in_continents.keys())

    @property
    def country_names(self):
        return list(
            map(
                lambda c: c["name"],
                self.__countries.values()
            )
        )
