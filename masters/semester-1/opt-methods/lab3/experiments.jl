include("parser.jl")
include("solver.jl")

files_num = 12

# for i in 1:files_num
#   problems = parse_file("./data/gap$i.txt")
  
#   for (j, problem) in enumerate(problems)
#     machine_count,
#     job_count, 
#     costs,
#     required_resources,
#     machine_resources = problem

#     print("\nSolving problem $j in file $i...")

#     (F, iterations), time = @timed solve(deepcopy(problem))

    # cost = sum(costs[i, j] for (i, j) in F)
    # machine_usages = []

    # for i in 1:machine_count
    #   machine_tasks = [t for t in F if t[1] == i]
    #   push!(machine_usages, (
    #     machine_resources[i],
    #     sum(required_resources[t[1], t[2]] for t in machine_tasks)
    #   ))
    # end

    # print("\nTime: $time, Iter: $iterations, Cost: $cost Usage: $machine_usages")
#   end
# end

problems = parse_file("./data/gap1.txt")

for i in 1:3
  (F, iterations), time = @timed solve(deepcopy(problems[i]))
  print("I $iterations t $time")
end