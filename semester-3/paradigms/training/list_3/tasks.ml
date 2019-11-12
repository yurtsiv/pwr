(*
  Task 1:

  a) f2: (int -> int -> 'a) -> 'a
  b) f2: (string -> 'a) -> string -> string -> 'a
*)

(* Task 2 *)
let curry3 f x y z = f (x, y, z)
let uncurry3 f (x, y, z) = f x y z

(* Task 3 *)
let sumProd =
  List.fold_left (fun (sum, prod) next -> (sum + next, sum * next)) (0, 1)


(*
  Task 4

  a) infinite loop if duplicate elems present (f.e. [1;1])

  b) discards duplicate elements (quicksort' [1;1;1] = [1])
*)

(* Task 5 a *)
let insertionsort pred xs =
  let rec insert elem = function
    | [] -> [elem]
    | hd::tail as l ->
      if pred hd elem
      then elem::l
      else hd::(insert elem tail)
  in let rec iterate acc = function
    | [] -> acc
    | hd::tail ->
      iterate (insert hd acc) tail
  in iterate [] xs

(* Task 5 b *)
let divide xs =
  let rec divide_help n first_half remaining =
    if n = 0 then (first_half, remaining)
    else match remaining with
      | [] -> (first_half, [])
      | hd::tail ->
        divide_help (n - 1) (hd::first_half) tail
  in divide_help ((List.length xs) / 2) [] xs

let rec merge comp xs ys =
  match xs, ys with
  | [], _ -> ys
  | _, [] -> xs
  | hd1::tail1, hd2::tail2 -> 
    if comp hd2 hd1 then hd1::(merge comp tail1 ys)
    else hd2::(merge comp xs tail2)

let rec mergesort comp xs =
  match xs with
  | [] -> []
  | [_] -> xs
  | _ ->
    let (first_half, second_half) = divide xs
    in merge comp (mergesort comp first_half) (mergesort comp second_half)
