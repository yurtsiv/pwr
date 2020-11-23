from utils import calc_edit_distance

TOLERABLE_DISTANCE = 2


class Country_names:
    def __init__(self):
        # Structure
        # { "PL": { "name": "Poland", "continent": "Europe" } }
        self.__countries = {}

    def add_country(self, code, name, continent):
        if self.__countries.get(code) is not None:
            return

        country_names = map(
            lambda n: n["name"],
            list(self.__countries.values())
        )

        for country_name in country_names:
            if calc_edit_distance(country_name, name) <= TOLERABLE_DISTANCE:
                return

        self.__countries[code] = {"name": name, "continent": continent}

    def get_name_by_code(self, code):
        country = self.__countries.get(code)

        if country is None:
            return None

        return country["name"]

    def get_code_by_name(self, name):
        codes = filter(
            lambda code:
            calc_edit_distance(
                self.__countries[code]["name"], name) <= TOLERABLE_DISTANCE,
            list(self.__countries.keys())
        )

        codes_list = list(codes)
        codes_num = len(codes_list)
        if codes_num == 0:
            return None

        if codes_num == 1:
            return codes_list[0]

        return codes_list

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
