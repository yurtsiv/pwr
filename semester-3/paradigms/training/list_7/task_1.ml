module type QUEUE_FUN =
sig
  type 'a t
  exception Empty of string
  val empty: unit -> 'a t
  val enqueue: 'a * 'a t -> 'a t
  val dequeue: 'a t -> 'a t
  val first: 'a t -> 'a
  val isEmpty: 'a t -> bool
end;;

(* Task 1 a *)
module QueueNaive =
struct
  type 'a t = 'a list
  exception Empty of string

  let empty () = []

  let enqueue (elem, q) = q @ [elem]

  let dequeue = function
      [] -> []
    | _::q -> q

  let first = function
      [] -> raise (Empty "Cannot call 'first' on an empty queue")
    | hd::_ -> hd

  let isEmpty = function
      [] -> true
    | _ -> false
end;;

(* Task 1 b *)
module QueueOptimal =
struct
  type 'a t = 'a list * 'a list
  exception Empty of string

  let empty () = ([], [])

  let enqueue (elem, (q_init, q_tail)) = (q_init, (elem::q_tail)) 

  let dequeue = function
      ([], []) as q -> q
    | ([], _::tail) -> (List.rev tail, [])
    | (_::init, tail) -> (init, tail) 

  let first = function
      ([], []) -> raise (Empty "Cannot call 'first' on an empty queue")
    | ([], tail) -> List.hd (List.rev tail) 
    | (hd::_, _) -> hd

  let isEmpty = function
      ([], []) -> true
    | _ -> false
end;;
