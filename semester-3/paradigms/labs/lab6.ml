let rec repeat xs repeats =
  match xs, repeats with
  | [], _ -> []
  | _, [] -> []
  | hd::tail, 0::repeats_t -> repeat tail repeats_t
  | hd::tail, times::repeats_t ->
    hd::(repeat xs ((times - 1)::repeats_t))
;;

"repeat:";;
repeat [3;2;1] [2;1;0;3];;
repeat [3;2;1] [2];;
repeat [] [2;2];;
repeat [3;2;1] [];;


