type 'a bt = Empty | Node of 'a * 'a bt * 'a bt;;

let treeFoldL func init tree =
  let rec getNodesInOrder = function
  | Empty -> []
  | Node(root, left, right) ->
    (getNodesInOrder left) @ [root] @ (getNodesInOrder right)
  in List.fold_left func init (getNodesInOrder tree)
;;

"Task 2 (treeFoldL)";;
(* 
        1
      2   3
    4    6
        5 7 
*)
let tt = Node(1,
              Node(2,
                    Node(4,
                         Empty,
                         Empty
                    ),
                    Empty
                  ),
              Node(3,
                    Node(6,
                          Node(5,
                               Empty,
                               Empty
                          ),
                          Node(7,
                                Empty,
                                Empty
                          )
                    ),
                    Empty
              )
          );;

treeFoldL (fun acc node -> acc ^ " " ^ (string_of_int node)) "" tt;;

treeFoldL (+) 0 Empty;;
