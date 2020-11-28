from operator import itemgetter
from utils import calc_edit_distance


class Subjects:
    def __init__(self):
        self.__subjs = {}

    def get_code(self, name):
        weighted_codes = []

        for code in self.__subjs.keys():
            dist = calc_edit_distance(name, self.__subjs[code])
            weighted_codes.append(
                (code, dist)
            )

        weighted_codes.sort(key=itemgetter(1))
        codes_num = len(weighted_codes)

        if codes_num == 0 or (codes_num > 1 and weighted_codes[0][1] == weighted_codes[1][1]):
            return None

        return weighted_codes[0]

    def add_subject(self, code, name):
        if self.__subjs.get(code) is not None:
            return -1

        self.__subjs[code] = name

        return len(self.__subjs)

    def get_name(self, code):
        return self.__subjs.get(code)

    def __str__(self):
        res = ""

        for code in self.__subjs:
            res += "\n%s: %s" % (code, self.__subjs[code])

        return res
