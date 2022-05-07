m = 6
n = 4

T = [3, 5, 2, 4]

q = [
  [1,0,0,0]
  [0,1,0,1]
  [1,0,0,0]
  [0,0,1,0]
  [1,1,1,0]
  [1,0,1,0]
]

# Czy musimy odczytać j-tą cechę z serwera i (0 lub 1)

# minimize obj: sum{j in 1:m, i in 1:n}
#   x[j, i] * T[i]
# subject to
#   sum{i in 1:n}: sum{j in 1:m} x[j, i] * q[j, i] = 1
