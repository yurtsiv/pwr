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
  type 'a t = EmptyQueue | Queue of 'a list
  exception Empty of string

  let empty () = EmptyQueue

  let enqueue = function
      (elem, EmptyQueue) -> Queue ([elem])
    | (elem, (Queue q)) -> Queue (q @ [elem])

  let dequeue = function
    | EmptyQueue | Queue ([_]) -> EmptyQueue
    | Queue (_::tail) -> Queue tail

  let first = function
      EmptyQueue -> raise (Empty "Cannot call 'first' on an empty queue")
    | Queue (hd::_) -> hd

  let isEmpty = function
      EmptyQueue -> true
    | _ -> false
end;;


(* Task 1 b *)
module QueueOptimal =
struct
  type 'a t = EmptyQueue | Queue of 'a list * 'a list
  exception Empty of string

  let empty () = EmptyQueue

  let enqueue = function
      (elem, EmptyQueue) -> Queue ([], [elem])
    | (elem, Queue (q_init, q_tail)) -> Queue (q_init, (elem::q_tail)) 

  let dequeue = function
    | EmptyQueue | Queue ([], [_]) | Queue ([_], [])  -> EmptyQueue
    | Queue ([], _::tail) -> Queue ((List.rev tail, []))
    | Queue (_::init, tail) -> Queue (init, tail) 

  let first = function
      EmptyQueue -> raise (Empty "Cannot call 'first' on an empty queue")
    | Queue ([], tail) -> List.hd (List.rev tail) 
    | Queue (hd::_, _) -> hd

  let isEmpty = function
      EmptyQueue -> true
    | _ -> false
end;;
