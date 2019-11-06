(*Task 1*)
let iterate init pred func =
  let rec iter acc =
    if (pred acc) then iter (func acc)
    else acc
  in iter init;;

(* Task 2 a*)
let init func n =
  if n < 0 then []
  else
    let seq = iterate [(n - 1)] (fun (hd::_) -> hd > 0) (fun acc -> ((List.hd acc) - 1)::acc)
    in List.map func seq;;

let sum l = List.fold_left (+.) 0. l;;

(*Task 2 b *)
(* let integral f a b =
  let calc_area x1 x2 = ((f (float_of_int x1)) +. (f (float_of_int x2))) /. 2. in
  let sum_parts = init (fun i -> calc_area (a + i) (a + i + 1)) (b - a) in
  sum sum_parts
 *)

"Task 1 (iterate)";;
iterate 0 (fun n -> n < 10) (fun n -> n + 1);;
iterate 0 (fun n -> n > 10) (fun n -> n + 1);;

"Task 2 A (init)";;
init (fun i -> i + 10) 10;;
init (fun i -> i + 10) 0;;
init (fun i -> i + 10) (-10);;

(* "Task 2 B (integral)";; *)
(* let quadratic x = x ** 2.;; *)

(* integral quadratic 0 4;;
integral quadratic 0 0;;
integral quadratic (-2) 0;;
*)
