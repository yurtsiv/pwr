subprog = 3
funcs = 3

r = [
  [3, 2, 1]
  [1, 2, 3]
  [4, 5, 2]
]

t = [
  [1, 2, 3],
  [3, 2, 1],
  [3, 5, 1]
]

M = 9

# minimize obj: sum{i in 1:subprog, j in 1:funcs}
#   x[i, j] * t[i, j]
#
# subject to {i in 1:subprog}: sum{j in 1:funcs} x[i, j] = 1
# subject to sum{i in 1:subprog, j in 1:funcs}: x[i, j] * r[i, j] <= M