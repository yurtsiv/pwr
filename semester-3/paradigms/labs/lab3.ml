(*Task 1*)
let iterate init pred func =
  let rec iter acc =
    if (pred acc) then iter (func acc)
    else acc
  in iter init;;

(* Task 2 a*)
let init func n =
  if n <= 0 then []
  else
    let seq = iterate [(n - 1)] (fun (hd::_) -> hd > 0) (fun acc -> ((List.hd acc) - 1)::acc)
    in List.map func seq;;

(*Task 2 b *)
let integral f a b n =
  let dx = (b -. a) /. (float_of_int n) in
  let func_vals = init (fun i -> f (a +. dx *. (float_of_int i))) (n + 1) in
  let rec calc_areas acc = function
    | [] | [_] -> acc
    | hd1::hd2::tail ->
      let area = ((hd1 +. hd2) /. 2.) *. dx
      in calc_areas (area::acc) (hd2::tail) in
  let sum = List.fold_left (+.) 0. in
  let areas = calc_areas [] func_vals in
  sum areas;;

"Task 1 (iterate)";;
iterate 0 (fun n -> n < 10) (fun n -> n + 1);;
iterate 0 (fun n -> n > 10) (fun n -> n + 1);;

"Task 2 A (init)";;
init (fun i -> i + 10) 10;;
init (fun i -> i + 10) 0;;
init (fun i -> i + 10) (-10);;

"Task 2 B (integral)";;

integral (fun x -> x) 0. 1. 10;;
integral (fun x -> x) 1. 0. 10;;
integral (fun x -> x) 0. 0. 10;;

integral sin 0. 3.14 1000;;