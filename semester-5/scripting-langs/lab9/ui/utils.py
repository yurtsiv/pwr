from logic.utils import get_closest_string
from logic.const import DATE_FORMAT

def try_parse_place(place, country_names):
    """
    Returns continent, country code, closest place
    """
    continents = country_names.continents

    if place == "World":
      return None, None, None

    if place in continents:
        return place, None, None

    country_code = country_names.get_code_by_name(place)
    if country_code is not None:
        return None, country_code, None
 
    closest_place = get_closest_string(
        list(continents) + country_names.country_names + ["World"],
        place
    )

    return None, None, closest_place

def format_result(result, country_names):
    res = "\n"
    res += "Country".ljust(30) + "Day".ljust(20) + "Cases".ljust(10) + "Deaths".ljust(10)
    res += "\n"
    res += "_" * 70
    res += "\n"

    for item in result:
        country_name = country_names.get_name_by_code(item["country_code"]) or ""
        day = item["day"].strftime(DATE_FORMAT) or ""
        cases = str(item["cases"]) or ""
        deaths = str(item["deaths"]) or ""

        row = country_name.ljust(30) + day.ljust(20) + cases.ljust(10) + deaths.ljust(10)
        res += row + "\n"
    
    res += "\n"

    return res