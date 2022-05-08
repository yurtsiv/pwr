using JuMP
using GLPK

# czasy wykonania zadań (wiersz - procesor, kolumna - zadanie)
t = [
  1 2 4 4
  3 1 2 4
  4 2 1 3
]

# n - liczba procesorów, m - liczba zadań do wykonania
(n, m) = size(t)

model = Model(GLPK.Optimizer)

# czasy startowe
@variable(model, start[1:n, 1:m] >= 0, Int)

# kolejność wykonania
@variable(model, p[1:m, 1:m], Bin)

# ostatnie zadanie
@variable(model, last_end >= 0, Int)

@objective(model, Min, last_end)

# dokładnie jedno zadanie jest wybrane dla danej pozycji
@constraint(model, [i = 1:m], sum(p[i, j] for j in 1:m) == 1)
@constraint(model, [j = 1:m], sum(p[i, j] for i in 1:m) == 1)

# start j-tego zadania na i-tym procesorze nie może być
# wcześniej końca j-tego zadania na poprzednim procesorze
@constraint(model, [i = 2:n, j = 1:m], start[i, j] <= start[i-1, j] + t[i-1, j])

# na danym procesorze może być wykonywane tylko jedno zadanie na raz


# wsyzstkie zostały zrobione przed ostatnim
@constraint(model, [i = 1:m], start[n, i] + t[n, i] <= last_end)

optimize!(model)

print(termination_status(model))

print("Cmax = $(objective_value(model))")

for i in 1:m, j in 1:m
  if value(p[i, j]) == 1
    println(i)
  end
end