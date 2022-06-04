# Stepan Yurtsiv, 246437

function parse_line(line)
  parsed_line = convert(String, lstrip(line))
  parsed_line = split(parsed_line, ' ')
  return map(v -> parse(Int, v), parsed_line)
end

function get_data_from_file(path)
  data = []

  open(path) do file
      for line in eachline(file)
          push!(data, parse_line(line))
      end
  end

  return data
end

function parse_file(path)
  data = get_data_from_file(path)
  
  problems_count = data[1][1]
  deleteat!(data, 1)

  idx = 1
  problem_idx = 1

  problems_set = []

  while idx < length(data)
      machine_count = data[idx][1]
      job_count = data[idx][2]

      idx += 1
      costs = Array{Int64}(undef, machine_count, job_count)
      j = 1
  
      for i in idx:(idx + machine_count - 1)
          tmp = deepcopy(data[i])

          while length(tmp) < job_count
              append!(tmp, deepcopy(data[i + 1]))
              deleteat!(data, i + 1)
          end

          for (k, value) in pairs(IndexStyle(tmp), tmp)
              costs[j, k] = value
          end

          j += 1
      end

      idx += machine_count

      machine_resources = Array{Int64}(undef, machine_count, job_count)
      j = 1
      for i in idx:(idx + machine_count - 1)
          tmp = deepcopy(data[i])
          
          while length(tmp) < job_count
              append!(tmp, deepcopy(data[i + 1]))
              deleteat!(data, i + 1)
          end

          for (k, value) in pairs(IndexStyle(tmp), tmp)
              machine_resources[j, k] = value
          end

          j += 1
      end
      idx += machine_count

      required_resources = deepcopy(data[idx])

      idx += 1

      push!(problems_set, (machine_count, job_count, costs, machine_resources, required_resources))

      problem_idx += 1
  end

  return problems_set
end