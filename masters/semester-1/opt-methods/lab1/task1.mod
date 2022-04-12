# Stepan Yurtsiv 246437
# Lista 1, zad. 1

param n, > 0;

param A{i in 1..n, j in 1..n} := 1 / (i + j - 1);
param b{i in 1..n} := sum{j in 1..n} 1 / (i + j - 1);
param c{i in 1..n} := b[i];

var x{ i in 1..n } >= 0;

minimize obj: sum{i in 1..n} c[i] * x[i];

subject to s{i in 1..n}: sum{j in 1..n} A[i, j] * x[j] = b[i];

solve;

param error := sqrt(sum{i in 1..n} (x[i] - 1) ** 2) / sqrt(n);

display x;
display error;

data;

param n := 7;

end;