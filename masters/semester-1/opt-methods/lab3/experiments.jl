import Statistics

include("parser.jl")
include("solver.jl")

files_num = 12

# for i in 1:files_num
#   problems = parse_file("./data/gap$i.txt")
  
#   for (j, problem) in enumerate(problems)


#     print("\nSolving problem $j in file $i...")

#     (F, iterations), time = @timed solve(deepcopy(problem))


    # print("\nTime: $time, Iter: $iterations, Cost: $cost Usage: $machine_usages")
#   end
# end

file = 1
problem_num = 3

problems = parse_file("./data/gap$file.txt")
problem = problems[problem_num]

machine_count,
job_count, 
costs,
required_resources,
machine_resources = problem

(F, iterations), tiem = @timed solve(deepcopy(problem))
cost = sum(costs[i, j] for (i, j) in F)


machine_usages = []
max_t = 0
used_t = 0

for i in 1:machine_count
  machine_tasks = [t for t in F if t[1] == i]
  allowed = machine_resources[i]
  used = sum(required_resources[t[1], t[2]] for t in machine_tasks)
  global max_t += allowed
  global used_t += used
  push!(machine_usages, (
    allowed,
    used,
    used / allowed
  ))
end

x = used_t / max_t

print("$iterations $time $cost $machine_usages $x")