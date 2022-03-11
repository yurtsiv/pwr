import matplotlib.pyplot as plt
from functools import total_ordering
import os
import sys

RESULTS_DIR = sys.argv[1]


def parse_param(line):
    return int(line.split(" ")[1])


def parse_block(block):
    lines = block.split("\n")

    return {
        "size": parse_param(lines[1]),
        "total_time": parse_param(lines[2]) / 1000,
        "time_until_first": parse_param(lines[3]) / 1000,
        "states": parse_param(lines[4]),
        "states_until_first": parse_param(lines[5]),
    }


def unflatten_results(results):
    return {
        "size": list(map(lambda x: x["size"], results)),
        "total_time": list(map(lambda x: x["total_time"], results)),
        "time_until_first": list(map(lambda x: x["time_until_first"], results)),
        "states": list(map(lambda x: x["states"], results)),
        "states_until_first": list(
            map(lambda x: x["states_until_first"], results))
    }


def format_datasets(datasets):
    s = ""

    s += ",".join(map(str, datasets[0]["size"]))
    for dataset in datasets:
        s += "\n"
        s += ",".join(map(str, dataset["total_time"]))

    s += "\n\n"

    s += ",".join(map(str, datasets[0]["size"]))
    for dataset in datasets:
        s += "\n"
        s += ",".join(map(str, dataset["time_until_first"]))

    s += "\n\n"

    s += ",".join(map(str, datasets[0]["size"]))
    for dataset in datasets:
        s += "\n"
        s += ",".join(map(str, dataset["states"]))

    s += "\n\n"

    s += ",".join(map(str, datasets[0]["size"]))
    for dataset in datasets:
        s += "\n"
        s += ",".join(map(str, dataset["states_until_first"]))

    return s


def print_graphs(datasets):
    size = datasets[0]["size"]

    plt.plot(size, datasets[0]["states"], label="Następna")
    plt.plot(size, datasets[1]["states"],
             label="Najbardziej ograniczona")
    # plt.plot(size, datasets[2]["states"], label="AC-3")
    plt.xlabel("Liczba zmiennych")
    plt.ylabel("Liczba sprawdzonych węzłów")
    plt.legend()
    plt.savefig(RESULTS_DIR + "/total_states.png")
    plt.clf()

    plt.plot(size, datasets[0]["states_until_first"], label="Następna")
    plt.plot(size, datasets[1]["states_until_first"],
             label="Najbardziej ograniczona")
    # plt.plot(size, datasets[2]["states_until_first"], label="AC-3")
    plt.xlabel("Liczba zmiennych")
    plt.ylabel("Liczba sprawdzonych węzłów")
    plt.legend()
    plt.savefig(RESULTS_DIR + "/states_until_first.png")
    plt.clf()

    plt.plot(size, datasets[0]["total_time"], label="Następna")
    plt.plot(size, datasets[1]["total_time"],
             label="Najbardziej ograniczona")
    # plt.plot(size, datasets[2]["total_time"], label="AC-3")
    plt.xlabel("Liczba zmiennych")
    plt.ylabel("Czas")
    plt.legend()
    plt.savefig(RESULTS_DIR + "/total_time.png")
    plt.clf()

    plt.plot(size, datasets[0]["time_until_first"], label="Następna")
    plt.plot(size, datasets[1]["time_until_first"],
             label="Najbardziej ograniczona")
    # plt.plot(size, datasets[2]["time_until_first"], label="AC-3")
    plt.xlabel("Liczba zmiennych")
    plt.ylabel("Czas")
    plt.legend()
    plt.savefig(RESULTS_DIR + "/time_until_first.png")
    plt.clf()


def parse_file(file_path):
    with open(file_path, 'r') as f:
        blocks = f.read().split("---")[1:]

        return unflatten_results(list(map(parse_block, blocks)))


def print_results(file_path, datasets):
    print_graphs(datasets)
    with open(file_path, 'w') as f:
        f.write(format_datasets(datasets))


datasets = []
files = sorted(
    filter(lambda f: f.endswith(".txt"), os.listdir(RESULTS_DIR)),
    key=lambda f: int(f[0])
)

for file_name in files:
    print(file_name)
    datasets.append(parse_file(RESULTS_DIR + "/" + file_name))

print_results(
    RESULTS_DIR + "/results.csv",
    datasets
)
