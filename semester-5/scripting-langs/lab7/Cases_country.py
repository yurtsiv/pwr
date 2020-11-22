from const import COUNTRY_CODE_COLUMN
from Cases_day import Cases_day

class Cases_country:
  def __init__(self, country_code, cases_days):
    self.__country_code = country_code
    self.__cases_days = {}

    for cases_day in cases_days:
      self.__cases_days[cases_day.day] = cases_day

  @classmethod
  def from_row(cls, row):
    columns = row.split('\t')
    country_code = columns[COUNTRY_CODE_COLUMN]
    cases_day = Cases_day.from_row(row)

    return cls(country_code, [cases_day])

  @classmethod
  def from_strings(cls, country_code, day_str, cases_str, deaths_str):
    cases_day = Cases_day.from_strings(day_str, cases_str, deaths_str)
    return cls(country_code, [cases_day])

  @property
  def country_code(self):
    return self.__country_code

  @property
  def total_cases(self):
    cases_days_list = list(self.__cases_days.values())
    cases = map(lambda cases_day: cases_day.cases, cases_days_list)
    return sum(cases)

  @property
  def total_deaths(self):
    cases_days_list = list(self.__cases_days.values())
    deaths = map(lambda cases_day: cases_day.deaths, cases_days_list)
    return sum(deaths)
  
  @property
  def all_days(self):
    return list(self.__cases_days.values())

  def add_cases_day(self, cases_day):
    self.__cases_days[cases_day.day] = cases_day

  def __str__(self):
    return "%s  %d  %d  %d" % (
      self.__country_code,
      len(self.__cases_days),
      self.total_cases,
      self.total_deaths
    )

  def __eq__(self, other):
    return self.total_cases == other.total_cases

  def __lt__(self, other):
    return self.total_cases < other.total_cases

  def __gt__(self, other):
    return self.total_cases > other.total_cases