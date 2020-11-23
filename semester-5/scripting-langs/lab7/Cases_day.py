from datetime import datetime
from const import DATE_COLUMN, CASES_COLUMN, DEATHS_COLUMN, DATE_FORMAT

class Cases_day:
    def __init__(self, day, cases, deaths):
        self.__day = day
        self.__cases = cases
        self.__deaths = deaths

    @classmethod
    def from_strings(cls, day_str, cases_str, deaths_str):
        day = datetime.strptime(day_str, "%d.%m.%Y")
        cases = int(cases_str)
        deaths = int(deaths_str)

        return cls(day, cases, deaths)

    @classmethod
    def from_row(cls, row):
        columns = row.split('\t')
        return cls.from_strings(
            columns[DATE_COLUMN],
            columns[CASES_COLUMN],
            columns[DEATHS_COLUMN]
        )

    @property
    def day(self):
        return self.__day

    @property
    def cases(self):
        return self.__cases

    @property
    def deaths(self):
        return self.__deaths

    def __str__(self):
        date_str = self.__day.strftime(DATE_FORMAT)
        return "%s  %d  %d" % (date_str, self.__cases, self.__deaths)
