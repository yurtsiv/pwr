let rec count_occur_of elem xs n =
  match xs with
  | [] -> n
  | hd::tail ->
    let next_n = if hd = elem then (n + 1) else n
    in count_occur_of elem tail next_n

let rec contains elem xs =
  match xs with
  | [] -> false
  | hd::tail -> if hd = elem then true else contains elem tail

let uniq xs =
  let rec uniq_help list uniq_elems =
    match list with
    | [] -> uniq_elems
    | hd::tail ->
      if contains hd uniq_elems then uniq_help tail uniq_elems
      else uniq_help tail (hd::uniq_elems)
  in List.rev (uniq_help xs [])

let count_occur_of_each xs =
  let rec count_occur_help uniq_elems original_list =
    match uniq_elems with
    | [] -> []
    | hd::tail -> (hd, count_occur_of hd original_list 0)::(count_occur_help tail original_list)
  and uniq_elems = uniq xs
  in count_occur_help uniq_elems xs

let divide xs =
  let rec divide_help remaining_list l1 l2 =
    match remaining_list with
    | [] -> (l1, l2)
    | hd::tail ->
      divide_help tail l2 (hd::l1)
  in divide_help xs [] []


let rec merge comp xs1 xs2 =
  match xs1, xs2 with
  | [], _ -> xs2
  | _, [] -> xs1
  | hd1::tail1, hd2::tail2 -> 
    if comp hd1 hd2 then hd1::(merge comp tail1 xs2)
    else hd2::(merge comp xs1 tail2)

let rec merge_sort comp xs =
  match xs with
  | [] -> []
  | [a] -> [a]
  | _ ->
    let (first_part, second_part) = divide xs
    in merge comp (merge_sort comp first_part) (merge_sort comp second_part)
;;

"Task #1";;
"Function count_occur";;
count_occur_of 1 [1;2;3;1;1] 0;;
count_occur_of "a" ["a";"b";"c";"a"] 0;;

"Function uniq";;
uniq [1;2;2;3;4;3;3;4;1];;
uniq ["a";"a";"b";"c";"d";"c";"b"];;


"Function count_occur_of_each";;
count_occur_of_each [1;2;3;1;3;3;3;4];;
count_occur_of_each ["d";"a";"b";"c";"a";"d"];;

"Task #2 Merge sort";;
"Function merge";;
merge (<) [1;4;5] [2;3];;

"Function divide";;
divide [1;2;3;4;5];;

"Function merge_sort"
let list_to_sort = [1;4;2;3;5];;
merge_sort (>) list_to_sort;;
merge_sort (<) list_to_sort;;

