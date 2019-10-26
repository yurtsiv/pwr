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
