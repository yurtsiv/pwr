import json
from calendar import monthrange
from datetime import datetime

from logic.utils import get_closest_string
from logic.const import DATE_FORMAT
from gui.const import MONTHS, YEAR

def format_result(result, country_names):
    padding = ' ' * 30
    res = "\n"
    res += padding + "Country".ljust(30) + "Day".ljust(20) + \
        "Cases".ljust(10) + "Deaths".ljust(10)
    res += "\n"
    res += padding + "_" * 70
    res += "\n"

    for item in result:
        country_name = country_names.get_name_by_code(
            item["country_code"]) or ""
        day = item["day"].strftime(DATE_FORMAT) or ""
        cases = str(item["cases"]) or ""
        deaths = str(item["deaths"]) or ""

        row = country_name.ljust(30) + day.ljust(20) + \
            cases.ljust(10) + deaths.ljust(10)
        res += padding + row + "\n"

    res += "\n"

    return res

def date_range_from_filters(filters):
    month_name, day_str = filters['month'], filters['day']

    if not month_name:
        return None

    day = None if day_str is None else int(day_str)

    month_num = MONTHS.index(month_name) + 1

    if day is None:
        (_, days_in_month) = monthrange(YEAR, month_num)
        return (
            datetime(YEAR, month_num, 1),
            datetime(YEAR, month_num, days_in_month)
        )

    return (
        datetime(YEAR, month_num, day),
        datetime(YEAR, month_num, day)
    )

def parse_saved_filters(file_name):
    with open(file_name, 'r') as file:
        data = json.load(file)        

        res = []

        for item in data:
            res.append({
                'country_name': item['country_name'],
                'continent': item['continent'],
                'month': item['month'],
                'day': item['day'],
                'sort_by': item['sort_by'],
                'rows_limit': item['rows_limit']
            })

        return data