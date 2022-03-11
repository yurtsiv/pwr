def read_param(file):
    return file.readline().split(":")[1]

def read_int_param(file):
    return int(read_param(file))

def read_float_param(file):
    return float(read_param(file))

def skip_lines(file, lines):
    for i in range(0, lines):
        file.readline()

def parse_tabu_header(file):
    iterations = read_int_param(file)
    neighbours_size = read_int_param(file)
    start_temperature = read_float_param(file)
    mutation_type = read_param(file)
    cooling_type = read_param(file)

    return {
        "iterations": iterations,
        "neighbours_size": neighbours_size,
        "start_temperature": start_temperature,
        "mutation_type": mutation_type,
        "cooling_type": cooling_type
    }


def parse_data(iterations, file):
    best = []
    current = []
    worst = []

    for e in range(0, iterations):
        # skip epoch number
        file.readline()

        chunks = file.readline().split(",")

        best.append(float(chunks[0]))
        current.append(float(chunks[1]))
        worst.append(float(chunks[2]))

    return (best, current, worst)

def parse_results(folder_path):
    params = None
    results = []
    best_fitnesses = []

    for i in range(0, 10):
        print("parsing file")
        file_path = folder_path + "/log" + str(i) + ".txt"
        with open(file_path) as file:
            if i == 0:
                params = parse_tabu_header(file)
            else:
                skip_lines(file, 5)

            results.append(parse_data(params["iterations"], file))

            best_fitnesses.append(
                read_float_param(file)
            )

    return (params, results, best_fitnesses)
