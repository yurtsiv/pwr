(*Task #1*)
let get_nth (a, b, c) elem =
  if elem = 1 then a
  else if elem = 2 then b
  else c
  
(*Task #2*)
let sum_and_mul s e =
  let rec aux n (sum, mul) =
    if n >= e then (sum, mul) else aux (n+1) (sum + n, mul * n)
  in
    if s < 0 || e < 0 || s >= e then (0, 1)
    else aux s (0, 1)

(*Task #3*)
let rec merge list1 list2 =
  match list1, list2 with
  | [], _ -> list2
  | _, [] -> list1
  | hd1::tail1, hd2::tail2 ->
    hd1::hd2::(merge tail1 tail2)

(*Task #4*)
let is_prime num =
  let rec check_is_prime n next_divisor =
    if n = next_divisor then true
    else if n <= 1 || (n mod next_divisor) = 0 then false
    else check_is_prime n (next_divisor + 1)
  in
    check_is_prime num 2
;;
 
"Task 1";;
get_nth (1, 2, 3) 1;;
get_nth (1, 2, 3) 2;;
get_nth (1, 2, 3) 3;;

"Task 2";;
sum_and_mul 1 5;;
sum_and_mul 1 1;;

"Task 3";;
merge [1;2] [3;4];;
merge [1;2] [3;4;5;6;7;8];;
merge [1;2;3;4;5] [6;7];;

"Task 4";;
is_prime 5;;
is_prime 4;;
is_prime 0;;
is_prime 1;;
is_prime (-1);;
