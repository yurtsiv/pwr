type 'a llist = LNil | LCons of 'a * 'a llist Lazy.t;;
type 'a lBT = LEmpty | LNode of 'a * (unit ->'a lBT) * (unit -> 'a lBT);;

(* Task 1 *)
let lrepeat times lxs =
  let rec lrepeat_help count = function
      LNil -> LNil
    | LCons(hd, tail) as lys ->
      if count = 0 then (lrepeat_help times (Lazy.force tail)) 
      else LCons(hd, lazy (lrepeat_help (count - 1) lys))
  in lrepeat_help times lxs


(* Task 2 *)
let lconstruct_fib () =
  let rec fib a b =
    LCons(a + b, lazy (fib b (a + b)))
  in LCons(0, lazy(LCons(1, lazy(fib 0 1))))

let rec lfib = lconstruct_fib () 

(* Task 3 a *)
let lBreadth ltree =
  let rec lBreadthHelp = function
    [] -> LNil
  | LEmpty::tail -> lBreadthHelp tail
  | LNode(root, lleft, lright)::tail ->
    LCons(root, lazy(lBreadthHelp (tail @ [lleft ();lright ()])))
  in lBreadthHelp [ltree]

(* Task 3 b *)
let rec lTree n =
  LNode(
    n,
    (function () -> lTree (2* n)),
    (function () -> lTree (2 * n + 1))
  )
