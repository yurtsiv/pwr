from statistics import mean
from datetime import datetime
from operator import itemgetter

from Person import Person
from const import DATE_FORMAT


class Student(Person):
    def __init__(self, names, surname, birthday, grades=[]):
        Person.__init__(self, names, surname, birthday)

        # Example
        # [("WF", 4)]
        self.__grades = grades

        # Instance of Subjects
        self.__subjects = None

    def add_grade(self, sub_code, grade):
        if grade < 0 or grade > 5:
            raise ValueError("Invalid value for grade: %d" % grade)

        grade_exists = any(
            [g[0] == sub_code and g[1] > 2 for g in self.__grades])

        can_add_grade = not grade_exists or grade < 3

        if not can_add_grade:
            raise ValueError(
                "Can't add grade %d for %s since there already is a grade > 2" % (grade, sub_code))

        self.__grades.append((sub_code, grade))

    def set_subjects(self, subjects):
        self.__subjects = subjects

    @property
    def average_grade(self):
        return mean(map(itemgetter(1), self.__grades))

    @classmethod
    def from_dict(cls, dict):
        grades = list(map(lambda g: (g[0], g[1]), dict["grades"]))

        return cls(
            dict["name"],
            dict["surname"],
            dict["birthday"],
            grades
        )

    def __str__(self):
        grades_str = "\n\nGRADES\n"
        for (subj_code, grade) in self.__grades:
            subj_name = subj_code if self.__subjects is None else self.__subjects.get_name(
                subj_code)

            grades_str += "\n%s: %d" % (subj_name, grade)

        return super().__str__() + grades_str + "\n\nAverage: " + str(self.average_grade)
