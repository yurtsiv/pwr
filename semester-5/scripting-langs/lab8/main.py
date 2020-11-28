from operator import attrgetter

from utils import read_json_data, unwrap_list, print_maybe_list
from Student import Student
from Worker import Worker
from Subjects import Subjects


def task_1(workers):
    target_workers = list(filter(lambda w: 40 <= w.age <= 50, workers))

    max_points_worker = max(
        target_workers, key=attrgetter("last_4_years_points"))

    max_points_workers = list(filter(
        lambda w: w.last_4_years_points == max_points_worker.last_4_years_points, target_workers))

    return unwrap_list(max_points_workers)


def sort_by_surname(students):
    return sorted(students, key=attrgetter("surname"))


def task_4(students):
    return sorted(students, reverse=True, key=attrgetter("average_grade"))


students_data = read_json_data("students.json")
workers_data = read_json_data("workers.json")
subjects_data = read_json_data("subjects.json")

students = list(map(Student.from_dict, students_data))
workers = list(map(Worker.from_dict, workers_data))
subjects = Subjects.from_list_of_lists(subjects_data)

for s in students:
    s.set_subjects(subjects)

print("\n---- Task 1 ----\n")
print_maybe_list(task_1(workers))

print("\n---- Task 2 ----\n")
print_maybe_list(sort_by_surname(students))

print("\n---- Task 3 ----\n")
print_maybe_list(sort_by_surname(workers))

print("\n---- Task 4 ----\n")
print_maybe_list(task_4(students))
