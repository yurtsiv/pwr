# Stepan Yurtsiv, 246437

using JuMP
using GLPK

include("./data.jl")

model = Model(GLPK.Optimizer)

# n - liczba funkcji, m - liczba podprogramów
(n, m) = size(r)

# macierz zmiennych binarynych, gdzie x[i,j] = 1, jeśli używamy podprogramu j do obliczenia funkcji i
@variable(model, x[1:n,1:m], Bin)

# minimalizujemy czas wykonaia progragmu
@objective(model, Min, sum(x[i,j] * t[i, j] for i in I, j in 1:m))

# zapewnia użycie dokładnie jednego podprogramu dla obliczania danej funkcji
@constraint(model, [i in I], sum(x[i,j] for j in 1:m) == 1)

# ograniczenie pamięciowe
@constraint(model, sum(x[i, j] * r[i, j] for i in 1:n, j in 1:m) <= M)

optimize!(model)

println(termination_status(model))

println("Czas wykonania programu: $(objective_value(model))")

mem = sum(value(x[i, j]) * r[i, j] for i in 1:n, j in 1:m)
println("Zużycie pamięci: $mem\n")

for i in 1:n, j in 1:m
  if value(x[i, j]) == 1
    println("Do obliczenia funkcji $i użyć podprogram $j")
  end
end