int: n = 5;
int: n_half = ceil(n / 2);

array[1..n, 1..n] of var {0, 1}: clicks;

constraint forall (x in 1..n, y in 1..n) (
  sum([
    clicks[x, y],
    if x > 1 then clicks[x - 1, y] else 0 endif,
    if x < n then clicks[x + 1, y] else 0 endif,
    if y > 1 then clicks[x, y - 1] else 0 endif,
    if y < n then clicks[x, y + 1] else 0 endif
  ]) mod 2 = if (
    (x = n_half /\ y in (n_half - 1)..(n_half + 1)) \/
    (y = n_half /\ x in (n_half - 1)..(n_half + 1))
  ) then 0 else 1 endif
);

solve satisfy;
