(*
  Task 1
  
  a) f1: ('a -> 'b -> 'c) -> 'a -> 'b -> 'c

  b) f2: 'a -> a''list -> 'c -> 'a list
*)

(* Task 2 *)
let any x = List.hd []


type 'a bt = Empty | Node of 'a * 'a bt * 'a bt
type 'a graph = Graph of ('a -> 'a list)

(* Task 3 *)
let tt = Node(1,
              Node(2,
                    Node(4,
                         Empty,
                         Empty
                    ),
                    Empty
                  ),
              Node(3,
                    Node(5,
                          Empty,
                          Node(6,
                                Empty,
                                Empty
                          )
                    ),
                    Empty
              )
          )

let breadthBT t = 
  let rec visit queue res =
    match queue with
    | [] -> res
    | Empty::tail -> visit tail res
    | Node(root, left, right)::tail ->
      visit (tail @ [left;right]) (root::res)
  in List.rev (visit [t] [])
