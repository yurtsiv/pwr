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

average = int(np.average(best_fitnesses))
worst = int(np.max(best_fitnesses))
best = int(np.min(best_fitnesses))
std = int(np.std(best_fitnesses))

with open(results_folder + "/analysis.txt", "w") as f:
    json.dump({
        "params": params,
        "average": average,
        "std": std,
        "worst": worst,
        "best": best,
    }, f, indent=2)
