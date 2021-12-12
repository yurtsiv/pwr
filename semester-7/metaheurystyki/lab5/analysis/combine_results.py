import json
import sys

base_folder = sys.argv[1]
alg = sys.argv[2]

problems = ["A-n32-k5", "A-n39-k5", "A-n45-k6", "A-n48-k7", "A-n54-k7", "A-n60-k9"]

result = ""

for problem in problems:
    with open(base_folder + "/" + problem + "/" + alg + "/analysis.txt") as file:
        res = json.load(file)

        result += '\t'.join([
            str(res["best"]),
            str(res["worst"]),
            str(res["average"]),
            str(res["std"])
        ]) + '\n'

with open(base_folder + "/results.txt", "w") as file:
	file.write(result)