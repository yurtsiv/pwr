from logic import calc_edit_distance, parse_data, transform_data, SORT_BY_KEYS
from const import MONTHS, YEAR
from calendar import monthrange
from datetime import datetime
from operator import itemgetter


# Examples

# Ukraine 14 august sort by cases limit to 10
# Europe January
# World

# Parts
# [country name | continent | World] [[day] month] [sort by cases | deaths] [limit to number]

help_text = """
A command has the following format:

<place> <date> sort by <sort_field> limit to <limit_number>

<place>        - country name or "World"
<date>         - day and month name or just month name (implicit year is 2020)
<sort_field>   - "deaths" or "cases"
<limit_number> - number of rows to output

Examples:

> Poland 14 January
> Poland February
> World June sort by deaths
> World 14 July sort by cases limit to 10
"""

def get_closest_string(strings, string):
    string_lower = string.lower()
    weighted_strings = map(
        lambda s: (
            s,
            calc_edit_distance(
                s.lower(), string_lower)
        ),
        strings
    )

    return min(weighted_strings, key=itemgetter(1))[0]

def parse_place(line, country_names):
    words = line.split(" ")
    place = words[0]
    line_rest = ' '.join(words[1:])

    if place == "World":
        return line_rest, None, None

    continents = map(lambda c: c.lower(), country_names.continents)

    if place in continents:
        return line_rest, place, None

    country_code = country_names.get_code_by_name(place)
    if country_code is not None:
        return line_rest, None, country_code
 
    closest_place = get_closest_string(
        list(continents) + country_names.country_names + ["World"],
        place
    )

    raise ValueError("Couldn't find the place called %s. Did you mean %s?" % (place, closest_place))
 
def parse_date(line):
    if line == "":
        raise ValueError("No date provided. Did you mean \"all time\"?")

    words = line.split(" ")

    if line.startswith("all time"):
        return ' '.join(words[2:]), None

    day = None
    try:
        day = int(words[0])
    except:
        pass
    
    month = words[0] if day is None else words[1]

    if month not in MONTHS:
        closest_month = get_closest_string(
            MONTHS,
            month
        )

        raise ValueError("Invalid value for month: %s. Did you mean %s?" % (month, closest_month))

    month_num = MONTHS.index(month) + 1

    if day is None:
        (first_day_of_month, last_day_of_month) = monthrange(YEAR, month_num)
        return ' '.join(words[1:]), (
            datetime(YEAR, month_num, first_day_of_month + 1),
            datetime(YEAR, month_num, last_day_of_month)
        )

    return ' '.join(words[2:]), (
        datetime(YEAR, month_num, day),
        datetime(YEAR, month_num, day)
    )

def parse_sort(line):
    if line == "" or not line.startswith("sort by"):
        return line, None
 
    words = line.split(" ")

    if len(words) == 2:
        raise ValueError("Sort key is not provided")
    
    sort_by_key = words[2]

    if sort_by_key not in SORT_BY_KEYS:
        raise ValueError("Invalid sort key provided")

    return ' '.join(words[3:]), sort_by_key

def parse_rows_limit(line):
    if line == "" or not line.startswith("limit to"):
        return line, None
 
    words = line.split(" ")

    if len(words) == 2:
        raise ValueError("Limit number is not provided")
    
    rows_limit = None
    try:
        rows_limit = int(words[2])
    except:
        raise ValueError("Invalid limit number provided: %s" % words[2])

    if rows_limit < 0:
        raise ValueError("Limit number can't be negative")
    
    return ' '.join(words[2:]), rows_limit

def exec_command(line):
    if line == "?":
        return print(help_text)

    line_rest, continent, country_code = parse_place(line, country_names)
    line_rest, date_range = parse_date(line_rest)
    line_rest, sort_by_key = parse_sort(line_rest)
    line_rest, rows_limit = parse_rows_limit(line_rest)

    for i in transform_data(cases_world, country_names, date_range=date_range, continent=continent, country_code=country_code, sort_by_key=sort_by_key, rows_limit=rows_limit):
        print(i)

print("Prasing the file. Please wait...")
cases_world, country_names = parse_data()
print("You can now enter commands. Type ? for help")

while True:
    line = input("> ").strip()

    try:
        exec_command(line)
    except ValueError as e:
        print(e)
    except Exception as e:
        print("Invalid command. See help by typing \"?\"")
        print(e)
