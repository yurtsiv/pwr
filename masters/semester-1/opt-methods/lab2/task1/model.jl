# Stepan Yurtsiv, 246437

using JuMP
using GLPK

include("./data.jl")

model = Model(GLPK.Optimizer)

# m - liczba cech, n - liczba serwerów
(m, n) = size(Q)

# lista zmiennych binarynych, gdzie x[j] = 1 jeśli musimy przeczytać dane z serwera j (i є 1..n)
@variable(model, x[1:n], Bin)

# minimalizujemy sumaryczny czas poszukiwania danych
@objective(model, Min, sum(x[j] * T[j] for j in 1:n))

# zapewnia przeczytanie wartości każdej cechy conajmniej raz
@constraint(model, [i = 1:m], sum(x[j] * Q[i, j] for j in 1:n) >= 1)

optimize!(model)

println(termination_status(model))

println("Sumaryczny czas: $(objective_value(model))")

println("Należy przeszukać serwery: ")
for (idx, val) in enumerate(x)
  if value(val) == 1
    println(idx)
  end
end