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
module QueueNaive: QUEUE_FUN =
struct
  type 'a t = 'a list
  exception Empty of string

  let empty () = []

  let enqueue (elem, q) = q @ [elem]

  let isEmpty q = q = []

  let dequeue q =
    if isEmpty q then []
    else List.tl q

  let first q =
    if isEmpty q then raise (Empty "Cannot call 'first' on an empty queue")
    else List.hd q
end;;



(* Task 1 b *)
module QueueOptimal: QUEUE_FUN =
struct
  type 'a t = 'a list * 'a list
  exception Empty of string

  let empty () = ([], [])

  let enqueue (elem, (q_init, q_tail)) = (q_init, (elem::q_tail)) 

  let isEmpty q = q = ([], [])

  let dequeue q =
    if isEmpty q then q
    else match q with
      | ([], _::tail) -> (List.rev tail, [])
      | (_::init, tail) -> (init, tail) 

  let first q =
    if isEmpty q then raise (Empty "Cannot call 'first' on an empty queue")
    else match q with
      | ([], tail) -> List.hd (List.rev tail) 
      | (hd::_, _) -> hd
end;;
