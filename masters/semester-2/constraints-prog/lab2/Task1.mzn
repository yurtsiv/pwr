% Use this editor as a MiniZinc scratch book
array[1..5, 1..5] of var 1..5: pieces;
array[1..5, 1..5, 1..4] of var {0, 1}: orient;

constraint forall(p in 1..5) (
  count_eq(pieces, p) = 5
);

constraint forall(x in {1, 5}, y in 1..5) (
  pieces[x,y] < 5
);

constraint forall(x in 1..5, y in {1, 5}) (
  pieces[x,y] < 5
);

constraint forall(x in {1, 5}, y in {1, 5}) (
  pieces[x,y] < 4
);

constraint forall(x in 1..5, y in 1..5) (
  if pieces[x,y] == 1 then (
    exists(i in 1..4) (orient[x, y, i] = 1)
  ) elseif pieces[x,y] == 2 then (
    (orient[x, y, 1] = 1 /\ orient[x, y, 3] = 1) \/
    (orient[x, y, 2] = 1 /\ orient[x, y, 4] = 1)  
  ) elseif pieces[x,y] == 3 then (
    exists(i in 1..3) (orient[x, y, i] + orient[x, y, i + 1] == 2)
  ) elseif pieces[x,y] == 4 then (
    sum([
      orient[x, y, 1],
      orient[x, y, 2],
      orient[x, y, 3],
      orient[x, y, 4]
    ]) == 3
  ) else (
    forall(i in 1..4) (orient[x, y, i] == 1)
  )
  endif
);

constraint forall(y in {2,4}, o in 1..4) (
  orient[1, y, o] = orient[2, y, o] /\
  orient[1, y, o] = orient[1, y + 1, o] /\
  orient[1, y, o] = orient[1, y - 1, o]
);


solve satisfy;