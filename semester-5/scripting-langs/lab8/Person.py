from datetime import datetime
from const import DATE_FORMAT


class Person:
    __person_count = 0

    @staticmethod
    def _validate_params(names, surname, birthday):
        if not isinstance(names, list):
            raise ValueError("'names' should be array. Got " + str(names) + " . Surname: " + surname)

        name = ' '.join(names)
        if len(names) > 3:
            raise ValueError("Can't specify more than 3 names for a person. Got: " + name)

        if not type(surname) == str:
            raise ValueError("Surname should be string. Got " + str(surname) + ". Person name: " + name)

        birthday_date = None
        try:
            birthday_date = datetime.strptime(birthday, DATE_FORMAT)
        except:
            raise ValueError("Could not parse birthday for " + name + " " + surname + ". The required format is " + DATE_FORMAT) 

        if birthday_date > datetime.today():
            raise ValueError("Birthday can't be in the future. Person name: " + name + " " + surname)

    def __init__(self, names, surname, birthday):
        Person._validate_params(names, surname, birthday)

        self.__names = names[:3]
        self.__surname = surname
        self.__birthday = datetime.strptime(birthday, DATE_FORMAT)

        self.__id = Person.__person_count
        Person.__person_count += 1

    @property
    def surname(self):
        return self.__surname

    @property
    def age(self):
        return datetime.today().year - self.__birthday.year

    def __str__(self):
        birthday_str = self.__birthday.strftime(DATE_FORMAT)
        name = ' '.join(self.__names)

        return "Full name: %s %s\nAge: %d\nBirthday: %s\nID: %d" % (name, self.__surname, self.age, birthday_str, self.__id)
