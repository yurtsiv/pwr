# Stepan Yurtsiv, 246437
using JuMP
using GLPK

# include("parser.jl")

function solve(problem)
  # liczba maszyn
  machine_count, 
  # liczba zadań
  job_count, 
  # zysk z wykonywania zadań na danej maszynie
  costs,
  # czas wykonywania zadań na danej maszynie
  required_resources,
  # maksymalny czas dostępności danej maszyny 
  machine_resources = problem

  M = 1:machine_count
  J = 1:job_count
  M_temp = [i for i in M]
  J_temp = [j for j in J]

  # graf pełny dwudzielny reprezentujaćy połaćzenie maszyna-zadanie
  G = [(i, j) for i in M for j in J]

  # rozwiązanie końcowe
  F = []

  iterations = 0

  while length(J_temp) > 0
    iterations += 1

    model = Model(GLPK.Optimizer)

    @variable(model, x[M, J] >= 0)

    @objective(model, Min, sum(costs[i, j] * x[i, j] for (i, j) in G))

    for j in J_temp
      edges = [e for e in G if e[2] == j]
      # kazde zadanie jest wykonywane na dokładnie jednej maszynie
      @constraint(model, sum(x[i, j2] for (i, j2) in edges) == 1)
    end

    for i in M_temp
      edges = [e for e in G if e[1] == i]
      # czas wykonywania zadań nie przekracza maksymalnego czasu dostępności maszyny
      @constraint(model, sum(x[i2, j] * required_resources[i2, j] for (i2, j) in edges) <= machine_resources[i])
    end

    optimize!(model)

    solution = value.(x)

    # usuwamy krawędzie które nie zostały wybrane
    filter!(((i, j),) -> solution[i, j] != 0, G)

    for i in M, j in J
      is_one = abs(solution[i, j] - 1.0) <= eps(Float64)

      if is_one
        # usuwamy zrobione zadania
        filter!(x -> x != j, J_temp)
        # dodajemy krawędź do wyniku końcowego
        push!(F, (i, j))
        # zmniejszamy dostępny czas danej maszyny
        machine_resources[i] -= required_resources[i, j]
      end
    end

    # usuwamy maszyny których stopień wierszchołka w grafie jest 1
    # lub stopień 2 i co najmniej jedno przypisane zadanie
    filter!(M_temp) do i
      d = length([e for e in G if e[1] == i])
      at_least_one_job_assigned = sum([solution[i, j] for j in J_temp]) >= 1
      should_remove = d == 1 || (d == 2 && at_least_one_job_assigned)

      !should_remove
    end
  end

  return F, iterations
end
