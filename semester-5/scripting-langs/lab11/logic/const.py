import os

DATE_COLUMN = 0
CASES_COLUMN = 4
DEATHS_COLUMN = 5
COUNTRY_NAME_COLUMN = 6
COUNTRY_CODE_COLUMN = 8
CONTINENT_COLUMN = 10
FILE_PATH = os.path.dirname(__file__) + "/Covid.txt"
DATE_FORMAT = "%d/%m/%Y"

SORT_BY_KEYS = [
    "deaths",
    "cases"
]
