from logic.utils import get_closest_string
from logic.logic import parse_data, transform_data
from logic.const import DATE_FORMAT, SORT_BY_KEYS
from ui.console import get_string, get_date, get_menu_choice, get_integer
from ui.utils import try_parse_place, format_result

place_help = """
Country name, continent or World (parts of the name should be joined by underscore)

Default: World
"""

def get_place(country_names):
    while True:
        place = get_string("Place", default="World")

        if place == "?":
            print(place_help)
            continue

        if place == "":
            return None, None

        continent, country_code, closest_place = try_parse_place(
            place, country_names)

        if closest_place is not None:
            print("Couldn't find the place called %s. Did you mean %s? See help by typing \"?\"" %
                  (place, closest_place))
            continue

        return continent, country_code


def get_date_range():
    default = "none"
    date_from = get_date("Date from", default=default, forma=DATE_FORMAT)
    date_to = get_date("Date to", default=default, forma=DATE_FORMAT)

    if date_from == default:
        date_from = None

    if date_to == default:
        date_to = None

    if date_from and date_to and date_from > date_to:
        print("NOTE: dates were swapped")
        date_from, date_to = date_to, date_from

    return (date_from, date_to)


def get_sort():
    choices = ["none"] + SORT_BY_KEYS
    sort_by_key = get_menu_choice("Sort by", choices, default="none")

    return None if sort_by_key == "none" else sort_by_key


def get_rows_limit():
    limit = get_integer("Rows limit", default="all")

    return None if limit == "all" else limit

print("Parsing the file. Please wait...")
cases_world, country_names = parse_data()

def run_cli():
  while True:
      continent, country_code = get_place(country_names)
      date_range = get_date_range()
      sort_by_key = get_sort()
      rows_limit = get_rows_limit()

      result = transform_data(
          cases_world,
          country_names,
          date_range=date_range,
          continent=continent,
          country_code=country_code,
          sort_by_key=sort_by_key,
          rows_limit=rows_limit
      )

      print(format_result(result, country_names))
