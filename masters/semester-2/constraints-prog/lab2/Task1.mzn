array[1..15, 1..4] of int: cards =
  [| 1, 0, 0, 0, % 1:  1 down
   | 0, 1, 0, 0, % 2:  1 left
   | 0, 0, 1, 0, % 3:  1 up
   | 0, 0, 0, 1, % 4:  1 right

   | 1, 0, 1, 0, % 5:  2 down
   | 0, 1, 0, 1, % 6:  2 left

   | 1, 1, 0, 0, % 7:  3 down
   | 0, 1, 1, 0, % 8:  3 left
   | 0, 0, 1, 1, % 9:  3 up
   | 1, 0, 0, 1, % 10: 3 right

   | 1, 1, 0, 1, % 11: 4 down
   | 1, 1, 1, 0, % 12: 4 left
   | 0, 1, 1, 1, % 13: 4 up
   | 1, 0, 1, 1  % 14: 4 right

   | 1, 1, 1, 1  % 15: 5 down
   |];

array[1..5, 1..5] of var 1..15: board;

constraint forall(x in 1..5) (
  cards[board[x, 1], 2] == 0 /\
  cards[board[x, 5], 4] == 0
);

constraint forall(y in 1..5) (
  cards[board[1, y], 3] == 0 /\
  cards[board[5, y], 1] == 0
);

constraint sum(x in 1..5, y in 1..5)(if board[x, y] in 1..4 then 1 else 0 endif) == 5;
constraint sum(x in 1..5, y in 1..5)(if board[x, y] in 5..6 then 1 else 0 endif) == 5;
constraint sum(x in 1..5, y in 1..5)(if board[x, y] in 7..10 then 1 else 0 endif) == 5;
constraint sum(x in 1..5, y in 1..5)(if board[x, y] in 11..14 then 1 else 0 endif) == 5;
constraint sum(x in 1..5, y in 1..5)(if board[x, y] == 15 then 1 else 0 endif) == 5;

constraint forall(x in 1..5) (
  cards[board[x, 1], 4] == cards[board[x, 2], 2] /\
  cards[board[x, 2], 4] == cards[board[x, 3], 2] /\
  cards[board[x, 3], 4] == cards[board[x, 4], 2] /\
  cards[board[x, 4], 4] == cards[board[x, 5], 2]
);

constraint forall(y in 1..5) (
  cards[board[1, y], 1] == cards[board[2, y], 3] /\
  cards[board[2, y], 1] == cards[board[3, y], 3] /\
  cards[board[3, y], 1] == cards[board[4, y], 3] /\
  cards[board[4, y], 1] == cards[board[5, y], 3]
);

solve satisfy;