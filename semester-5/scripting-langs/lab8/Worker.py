from itertools import groupby
from operator import itemgetter
from datetime import datetime

from Person import Person


class Worker(Person):
    def __init__(self, names, surname, birthday, publications=[]):
        Person.__init__(self, names, surname, birthday)

        # Example
        # [(2010, 10)]
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

    @property
    def last_4_years_points(self):
        current_year = datetime.today().year
        total_points = 0

        for y in range(current_year - 3, current_year + 1):
            pubs = filter(lambda pub: pub[0] == y, self.__publications)
            total_points += Worker._get_total_points(pubs)

        return total_points

    @property
    def empty_years(self):
        res = []

        for year, pubs in Worker._group_pubs(self.__publications):
            points_in_year = Worker._get_total_points(pubs)

            if points_in_year == 0:
                res.append(year)

        return res

    @classmethod
    def from_dict(cls, dict):
        pubs = list(map(lambda p: (p[0], p[1]), dict["publications"]))

        return cls(
            dict["name"],
            dict["surname"],
            dict["birthday"],
            pubs
        )

    def __str__(self):
        pubs_str = "\n\nPublications:\n"

        for year, pubs in Worker._group_pubs(self.__publications):
            points_in_year = Worker._get_total_points(pubs)

            pubs_str += "\n%d: %d" % (year, points_in_year)

        return super().__str__() + pubs_str
