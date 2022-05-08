using JuMP
using GLPK

include("./data.jl")
include("./gantt.jl")

# n - liczba procesorów, m - liczba zadań do wykonania
(n, m) = size(T)

# wartość niprzekraczalna przez maksymalny czas wykonania wszystkich zadań
M = sum(T)

# wszystkie permutacje kolejności wykonania zadań
ORDERS = [(j, i, k) for j in 1:n, i in 1:m, k in 1:m if i < k]

model = Model(GLPK.Optimizer)

# czasy startowe
@variable(model, start_times[1:n, 1:m] >= 0, Int)

# kolejność wykonanywania zadań
# order[1, 1, 2] = 0 oznacza, że zadanie 2 jest wykonywane póżniej niż zadanie 1 na procesorze 1
# aczkolwiek nie znaczy to, że zadanie 2 musi być tuż po 1
@variable(model, order[ORDERS], Bin)

# czas zakończenia ostatniego zadania
@variable(model, last_end >= 0, Int)

@objective(model, Min, last_end)

# start j-tego zadania na i-tym procesorze nie może być
# wcześniej końca j-tego zadania na poprzednim procesorze
@constraint(model, [i = 2:n, j = 1:m], start_times[i, j] >= start_times[i-1, j] + T[i-1, j])

# na danym procesorze może być wykonywane tylko jedno zadanie na raz (jest wykorzystany big-M trick)
@constraint(model, [(j, i, k) in ORDERS], start_times[j, i] - start_times[j, k] + M * order[(j, i, k)] >= T[j, k])
@constraint(model, [(j, i, k) in ORDERS], start_times[j, k] - start_times[j, i] + M * (1 - order[(j, i, k)]) >= T[j, i])

# wsyzstkie zadania muszą być zakończone przed zakończenim ostatniego
@constraint(model, [i = 1:m], start_times[n, i] + T[n, i] <= last_end)

optimize!(model)

print("Cmax = $(objective_value(model))\n\n")

gantt_chart(start_times, T, Int64(value(last_end)))