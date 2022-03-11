def read_param(file):
    return file.readline().split(":")[1]


def read_int_param(file):
    return int(read_param(file))


def read_float_param(file):
    return float(read_param(file))


def skip_header(file):
    for i in range(0, 8):
        file.readline()


def parse_header(file):
    epochs = read_int_param(file)
    population = read_int_param(file)
    selection_type = read_param(file)
    tournament_size = read_int_param(file)
    mutation_chance = read_float_param(file)
    max_segment_move = read_int_param(file)
    crossover_chance = read_float_param(file)
    split_segment_chance = read_float_param(file)

    return {
        "epochs": epochs,
        "population": population,
        "split_segment_chance": split_segment_chance,
        "crossover_chance": crossover_chance,
        "max_segment_move": max_segment_move,
        "mutation_chance": mutation_chance,
        "tournament_size": tournament_size,
        "selection_type": selection_type
    }


def parse_data(epochs, file):
    # skip first entry
    file.readline()
    file.readline()

    average = []
    best = []
    worst = []

    for e in range(0, epochs - 1):
        # skip epoch number
        file.readline()

        chunks = file.readline().split(",")

        average.append(float(chunks[0]))
        best.append(float(chunks[1]))
        worst.append(float(chunks[2]))

    return (average, best, worst)


def parse_results(folder_path):
    params = None
    results = []
    best_fitnesses = []

    for i in range(0, 10):
        file_path = folder_path + "/log" + str(i) + ".txt"
        with open(file_path) as file:
            if i == 0:
                params = parse_header(file)
            else:
                skip_header(file)

            results.append(parse_data(params["epochs"], file))

            best_fitnesses.append(
                read_float_param(file)
            )

    return (params, results, best_fitnesses)
