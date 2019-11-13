(* Task 1 *)
type 'a llist = LNil | LCons of 'a * (unit -> 'a llist)

let rec lfrom k = LCons (k, function () -> lfrom (k+1))

let rec ltake lxs =
  match lxs with
    (0, _) -> []
  | (_, LNil) -> []
  | (n, LCons(x,xf)) -> x::ltake(n-1, xf())
  
let l = lfrom 10

let lappend elem list =
  match list with
    LNil -> LCons(elem, function () -> LNil)
  | LCons(hd, tailf) ->
      LCons(elem, function () -> LCons(hd, tailf))

let al = lappend 100 l


let lsplit lxs =
  let rec help (even_i, odd_i) i = function
      LNil -> (even_i, odd_i)
    | LCons(hd, tailf) -> 
      if i mod 2 = 0 then help ((lappend hd even_i), odd_i) (i + 1) (tailf ())
      else help (even_i, (lappend hd odd_i)) (i + 1) (tailf ())
  in help (LNil, LNil) 0 lxs


