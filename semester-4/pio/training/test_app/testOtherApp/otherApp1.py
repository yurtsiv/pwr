#! /usr/bin/env python3

import sys
import pickle
import os.path

class Grade:
    def __init__(self, number, subject):
        self.number = number
        self.subject = subject

class Student:
    def __init__(self, name, surname):
        self.name = name
        self.surname = surname
        self.grades = []
        #self.grades.append(Grade(2))

    def addGrade(self, number, subject):
        self.grades.append(Grade(number, subject))

    def getGrade(self, i):
        return self.grades[i].number, self.grades[i].subject

class Subject:
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return self.name

def isCorrect(text):
    if(len(text) == 1):
        return False
    if(ord(text[0]) >= ord('A') and ord(text[0]) <= ord('Z')):
        pass
    else: return False
    for letter in text:
        if(ord(letter) >= ord('A') and ord(letter) <= ord('Z')):
            pass
        elif(ord(letter) >= ord('a') and ord(letter) <= ord('z')):
            pass
        else:
            return False
    return True

def existsSubj(name):   #position of subject in list
    i = 0
    for subj in subjects:
        if(subj == name):
            return i
        i += 1
    return -1

def existsStud(name, surname):  #position of student in list
    i = 0
    for stud in students:
        if(stud.name == name and stud.surname == surname):
            return i
        i += 1
    return -1

###############################################################################
#metody z listy#
###############################################################################

def addStud(name, surname):
    if(isCorrect(name) and isCorrect(surname)):
        if(existsStud(name, surname) == -1):
            students.append(Student(name, surname))
            return True
    return False

def addSubj(name):
    if isCorrect(name):
        if(existsSubj(name) == -1):
            subjects.append(name)
            return True
    return False

def delStud(name, surname):
    if(isCorrect(name) and isCorrect(surname)):
        i = existsStud(name, surname)
        if(i>=0):
            students.pop(i)
            return True
    return False

def delSubj(name):
    if isCorrect(name):
        i = existsSubj(name)
        if(i>=0):
            subjects.pop(i)
            for stud in students:
                for i in range(len(stud.grades)-1, -1, -1):
                    if(stud.grades[i].subject == name):
                        stud.grades.pop(i)
            return True
    return False

def countStud():
    return len(students)

def countSubj():
    return len(subjects)

def setGrade(name, surname, nameSub, grade):
    number = int(grade)
    if(number >= 2 and number <= 5):
        iStud = existsStud(name, surname)
        if iStud >= 0:
            if existsSubj(nameSub) >= 0:
                students[iStud].addGrade(number, nameSub)
                return True
    return False

def average(name, surname, nameSub):
    sum = 0
    i = 0
    iStud = existsStud(name, surname)
    if iStud >= 0:
        if existsSubj(nameSub) >= 0:
            for grade in students[iStud].grades:
                if(grade.subject == nameSub):
                    i += 1
                    sum += int(grade.number)
    if(sum == 0):
        return 0.0
    return round(sum/i,1)




students = []
subjects = []

if(os.path.exists('config.dictionary')):
    with open('config.dictionary', 'rb') as config_dictionary_file:
        config_dictionary = pickle.load(config_dictionary_file)

        # After config_dictionary is read from file
        students, subjects = config_dictionary
done = False

if(len(sys.argv) == 1 or len(sys.argv) == 2):
    done = True
    print("ERROR")
elif sys.argv[1] == "add":
    if sys.argv[2] == "student":
        done = True
        if(len(sys.argv) != 5):
            print("ERROR")
        else:
            if(addStud(sys.argv[3], sys.argv[4])):
                print("OK")
            else: print("ERROR")
    elif sys.argv[2] == "subject":
        done = True
        if (len(sys.argv) != 4):
            print("ERROR")
        else:
            if(addSubj(sys.argv[3])):
                print("OK")
            else: print("ERROR")
elif sys.argv[1] == "del":
    if sys.argv[2] == "student":
        done = True
        if (len(sys.argv) != 5):
            print("ERROR")
        else:
            if(delStud(sys.argv[3], sys.argv[4])):
                print("OK")
            else: print("ERROR")
    elif sys.argv[2] == "subject":
        done = True
        if (len(sys.argv) != 4):
            print("ERROR")
        else:
            if(delSubj(sys.argv[3])):
                print("OK")
            else: print("ERROR")
elif sys.argv[1] == "count":
    done = True
    if (len(sys.argv) != 3):
        print("ERROR")
    else:
        if sys.argv[2] == "students":
            print(countStud())
        elif sys.argv[2] == "subjects":
            print(countSubj())
elif sys.argv[1] == "set":
    done = True
    if (len(sys.argv) != 7):
        print("ERROR")
    elif(float(sys.argv[6]) != int(float(sys.argv[6]))):
        print("ERROR")
    else:
        if sys.argv[2] == "grade":
            done = True
            if(setGrade(sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6])):
                print("OK")
            else: print("ERROR")
elif sys.argv[1] == "average":
    done = True
    print(average(sys.argv[2], sys.argv[3], sys.argv[4]))
elif sys.argv[1] == "debug":
    print(subjects)
    print(students)

if not done:
    print("ERROR")

tab = students, subjects
with open('config.dictionary', 'wb') as config_dictionary_file:
    pickle.dump(tab, config_dictionary_file)
