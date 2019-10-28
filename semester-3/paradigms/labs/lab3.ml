(* Task 1*)
let iterate pred func =
  let rec iter count acc =
    if (pred count) then (iter (count + 1) ((func count)::acc))
    else List.rev acc
  in iter 0 []

(* Task 2 a*)
let init func n =
  iterate (fun i -> i < n) (fun i -> (func i))

let sum l = List.fold_left (+.) 0. l

(*Task 2 b *)
let integral f a b =
  let calc_area x1 x2 = ((f (float_of_int x1)) +. (f (float_of_int x2))) /. 2. in
  let sum_parts = init (fun i -> calc_area (a + i) (a + i + 1)) (b - a) in
  sum sum_parts
;;

"Task 1 (iterate)";;
iterate (fun i -> i < 10) (fun i -> i);;
iterate (fun i -> i < 0) (fun i -> i);;
iterate (fun i -> i < (-10)) (fun i -> i);;

"Task 2 A (init)";;
init (fun i -> i + 1) 10;;
init (fun i -> i + 1) 0;;
init (fun i -> i + 1) (-10);;

"Task 2 B (integral)";;
integral (fun x -> x) 0 4;;
integral (fun x -> x) 4 0;;
integral (fun x -> x) 0 0;;
integral (fun x -> x) (-2) 0;;

