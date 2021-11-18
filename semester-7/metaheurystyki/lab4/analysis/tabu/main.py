import matplotlib.pyplot as plt
import sys
import json
import numpy as np

from parse import parse_results

if len(sys.argv) < 2:
    raise "Pass a folder to analyse"

results_folder = sys.argv[1]

(params, results, best_fitnesses) = parse_results(results_folder)


iter_num = len(results[0][0])
experiments_num = len(results[0])

average = []
worst = []
for iter in range(0, iter_num):
    best_sum = 0
    worst_sum = 0

    for experiment in range(0, experiments_num):
        best_sum += results[experiment][0][iter]
        worst_sum += results[experiment][2][iter]

    average.append(best_sum / experiments_num)
    worst.append(worst_sum / experiments_num)

def plot():
    fig, ax = plt.subplots(figsize=(20, 10))

    best = []
    current = []
    worst_neighbour = []
    average_neighbour = []

    experiment = results[0];
    for iter in range(0, iter_num):
        best.append(experiment[0][iter])
        current.append(experiment[1][iter])
        worst_neighbour.append(experiment[3][iter])
        average_neighbour.append(experiment[4][iter])

    ax.plot(best, label="Best", linewidth=1)
    ax.plot(current, label="Current", linewidth=1)
    ax.plot(worst_neighbour, label="Worst neighbour", linewidth=1)
    ax.plot(average_neighbour, label="Average neighbour", linewidth=1)

    ax.set_xlabel("Iteration")
    ax.set_ylabel("Fitness")
    ax.legend()

    plt.savefig(results_folder + "/analysis.png")

the_best_fit_idx = np.argmin(best_fitnesses)

plot()

with open(results_folder + "/analysis.txt", "w") as f:
    json.dump({
        "params": params,
        "average": np.average(average),
        "average_std": np.std(average),
        "worst_avg": np.average(worst),
        "the_best": best_fitnesses[the_best_fit_idx],
        "the_best_idx": str(the_best_fit_idx)
    }, f, indent=2)
