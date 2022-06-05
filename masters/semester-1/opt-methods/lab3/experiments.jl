import Statistics

include("parser.jl")
include("solver.jl")

files_num = 12

print("Problem,time,iterations,usage_ratio_per_machine,total_allowed_machine_usage,total_machine_usage,total_machine_usage_ratio")

for i in 1:files_num
  problems = parse_file("./data/gap$i.txt")
  
  for (j, problem) in enumerate(problems)
    machine_count,
    job_count, 
    costs,
    required_resources,
    machine_resources = problem

    (F, iterations), time = @timed solve(deepcopy(problem))
 
    machine_usages = []
    total_allowed_usage = 0
    total_usage = 0

    for i in 1:machine_count
      machine_tasks = [t for t in F if t[1] == i]
      allowed = machine_resources[i]
      used = sum(required_resources[t[1], t[2]] for t in machine_tasks)
      total_allowed_usage += allowed
      total_usage += used
      ratio = used / allowed

      @assert ratio <= 2

      push!(machine_usages,round(ratio, digits=1))
    end

    total_usage_ratio = total_usage / total_allowed_usage
    machine_usages_str = join(machine_usages, " ")

    print("\nProblem $j in file $i,$(time * 1000),$iterations,$machine_usages_str,$total_allowed_usage,$total_usage,$total_usage_ratio")
  end
end