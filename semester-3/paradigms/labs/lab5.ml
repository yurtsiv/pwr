(* Task 1 *)
type 'a llist = LNil | LCons of 'a * (unit -> 'a llist)

let lsplit lxs =
  let rec get_even = function
    LNil -> LNil
  | LCons(hd, tail_f) ->
    match (tail_f ()) with
      LNil -> LCons(hd, function () -> LNil)
    | LCons(_, next_tail_f) ->
        LCons(hd, function() -> get_even (next_tail_f ())) in

  match lxs with
    LNil -> (LNil, LNil)
  | LCons(hd, tailf) ->
    (get_even lxs, get_even (tailf ()))

let rec lfrom k = LCons (k, function () -> lfrom (k+1))

let rec ltake lxs =
  match lxs with
    (0, _) -> []
  | (_, LNil) -> []
  | (n, LCons(x,xf)) -> x::ltake(n-1, xf())
;;

"Task 1";;
let (odd, even) = lsplit (lfrom 1);;
ltake (10, odd);;
ltake (10, even);;

lsplit LNil;;