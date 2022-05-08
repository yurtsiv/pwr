using JuMP
using GLPK

model = Model(GLPK.Optimizer)

n = 4

@variable(model, 1 <= x[1:n] <= n, Int)

@objective(model, Max, sum(x))

@constraint(model, sum(x) == (n * (n - 1)) / 2)
