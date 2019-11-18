let rec repeat_elem elem times =
  if times = 0 then []
  else elem::(repeat_elem elem (times - 1))

let rec repeat xs repeats =
  match xs, repeats with
  | [], _ -> []
  | _, [] -> []
  | hd::tail, times::repeats_t ->
    (repeat_elem hd times) @ (repeat tail repeats_t)
;;

"repeat_elem:";;
repeat_elem 1 3;;
repeat_elem 1 0;;

"repeat:";;
repeat [3;2;1] [2;1;0;3];;
repeat [3;2;1] [2];;
repeat [] [2;2];;
repeat [3;2;1] [];;


