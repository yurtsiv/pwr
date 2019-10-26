(* Task 1: Stack length = 1 (run time optimization) *)

let rec fib n =
  if n = 0 then 0
  else if n = 1 then 1
  else fib (n - 1) + fib (n - 2)

let fibTail n =
  let rec fib_help prev2 prev1 count =
    if count = 1 then prev1
    else fib_help prev1 (prev1 + prev2) (count - 1)
  in fib_help 0 1 n


let root3 num =
  let epsilon = 1e-55 in

  let is_precise_enough x a =
    abs_float (x ** 3. -. a) <= epsilon *. (abs_float a) in

  let calc_next_x prev_x =
    prev_x +. (num /. (prev_x *. prev_x) -. prev_x) /. 3. in

  let rec root3_help prev_x =
    if is_precise_enough prev_x num then prev_x
    else root3_help (calc_next_x prev_x) in

  let initial_x = if num <= 1. then num else num /. 3. in
 
  root3_help initial_x
 