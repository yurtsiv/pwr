from itertools import groupby
from operator import itemgetter 
from datetime import datetime
from Person import Person
from const import DATE_FORMAT


class Worker(Person):
  def __init__(self, names, surname, birthday, publications = []):
    Person.__init__(self, names, surname, birthday)

    self.__publications = publications
  
  def add_publication(self, year, points):
    self.__publications.append((year, points))
  
  @staticmethod
  def _get_total_points(pubs):
    return sum(map(itemgetter(1), pubs))
  
  @staticmethod
  def _group_pubs(pubs):
    sorted_pubs = sorted(pubs, key=itemgetter(0))
    return groupby(sorted_pubs, key=itemgetter(0))
  
  def get_last_4_years_points(self):
    current_year = datetime.today().year
    total_points = 0

    for y in range(current_year - 3, current_year + 1):
      pubs = filter(lambda pub: pub[0] == y, self.__publications)
      total_points += Worker._get_total_points(pubs)
    
    return total_points
  
  def empty_years(self):
    res = []

    for year, pubs in Worker._group_pubs(self.__publications):
      points_in_year = Worker._get_total_points(pubs)

      if points_in_year == 0:
        res.append(year)

    return res
  
  def __str__(self):
    pubs_str = "\n\n-- Publications --\n"

    for year, pubs in Worker._group_pubs(self.__publications):
      points_in_year = Worker._get_total_points(pubs)

      pubs_str += "\n%d: %d" % (year, points_in_year)

    return super().__str__() + pubs_str



def date(str):
  return datetime.strptime(str, DATE_FORMAT)


a = Worker(
  ["Stepan"],
  "u",
  date('09/01/1999'),
  [
    (2020, 0),
    (2000, 10),
    (2000, 11),
    (2015, 10),
    (2016, 10),
    (2016, 10),
    (2021, 1),
    (2017, 10),
    (2017, 10),
    (2018, 10),
    (2019, 10),
    (2020, 0),
    (2021, 0),
    (2021, 0),
    (2021, 0),
    (2021, 0),
  ]
)

print(a)