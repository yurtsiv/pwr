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
    fig, ax = plt.subplots(figsize=(15, 10))

    best = []
    current = []

    experiment = results[0];
    for iter in range(0, iter_num):
        best.append(experiment[0][iter])
        current.append(experiment[1][iter])

    ax.plot(best, label="Best", linewidth=1)
    ax.plot(current, label="Current", linewidth=1)

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

best_at_iter = []
for iter in range(0, iter_num):
    best_at_iter.append(results[0][0][iter])

with open(results_folder + "/analysis.txt", "w") as f:
    json.dump({
        "params": params,
        "average": average,
        "std": std,
        "worst": worst,
        "best": best,
        "best_arr": best_fitnesses,
        "best_at_iter_first_experiment": best_at_iter
    }, f, indent=2)