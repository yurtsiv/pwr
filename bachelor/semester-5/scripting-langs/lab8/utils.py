import os
import json


def calc_edit_distance(s, t, costs=(1, 1, 1)):
    rows = len(s) + 1
    cols = len(t) + 1

    dist = [[0 for x in range(cols)] for x in range(rows)]

    for row in range(1, rows):
        dist[row][0] = row

    for col in range(1, cols):
        dist[0][col] = col

    for col in range(1, cols):
        for row in range(1, rows):
            cost = 0 if s[row - 1] == t[col-1] else 1

            dist[row][col] = min(dist[row-1][col] + 1,
                                 dist[row][col-1] + 1,
                                 dist[row-1][col-1] + cost)  # substitution

    return dist[rows - 1][cols - 1]


def read_json_data(file_name):
    file_path = os.path.dirname(__file__) + "/data/" + file_name

    with open(file_path, 'r') as json_file:
        return json.loads(json_file.read())


def unwrap_value_from_list(l):
    if len(l) == 1:
        return l[0]

    return l


def print_maybe_list(l):
    if type(l) == list:
        for elem in l:
            print(elem)
            print('\n________________________________\n')
    else:
        print(l)
