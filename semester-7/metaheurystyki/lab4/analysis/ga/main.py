import matplotlib.pyplot as plt
import sys
import json
import numpy as np

from parse import parse_results

if len(sys.argv) < 2:
    raise "Pass a folder to analyse"

results_folder = sys.argv[1]

(params, results, best_fitnesses) = parse_results(results_folder)

def plot():
    average = []
    best = []
    worst = []

    epochs_num = len(results[0][0])
    experiments_num = len(results[0])

    for epoch in range(0, epochs_num):
        average_sum = 0
        best_sum = 0
        worst_sum = 0

        for experiment in range(0, experiments_num):
            average_sum += results[experiment][0][epoch]
            best_sum += results[experiment][1][epoch]
            worst_sum += results[experiment][2][epoch]

        average.append(average_sum / experiments_num)
        best.append(best_sum / experiments_num)
        worst.append(worst_sum / experiments_num)

    fix, ax = plt.subplots(figsize=(20, 10))

    ax.plot(average, label="Average")
    ax.plot(best, label="Best")
    ax.plot(worst, label="Worst")
    ax.set_xlabel("Epoch")
    ax.set_ylabel("Fitness")
    ax.legend()

    plt.savefig(results_folder + "/analysis.png")

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
