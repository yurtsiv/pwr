module type QUEUE_MUT =
sig
 type 'a t
 exception Empty of string
 exception Full of string
 val empty: int -> 'a t
 val enqueue: 'a * 'a t -> unit
 val dequeue: 'a t -> unit
 val first: 'a t -> 'a
 val isEmpty: 'a t -> bool
 val isFull: 'a t -> bool
end;;

module QueueMut: QUEUE_MUT =
struct
  type 'a t = {
    mutable f: int;
    mutable r: int;
    mutable arr: 'a option array;
  }

  exception Empty of string
  exception Full of string

  let empty len = {f = (-1); r = (-1); arr = Array.make len None}

  let isFull {f; r; arr} =
    (f = 0 && r = (Array.length(arr) - 1)) ||
    (f = (r + 1))
  
  let isEmpty q = q.f = (-1)

  let enqueue (elem, q) =
    if isFull q then raise (Full "The queue is full")
    else if isEmpty q then
      let _ = q.f <- 0 in
      let _ = q.r <- 0 in
      q.arr.(q.r) <- Some elem
    else
      let _ = q.r <- (q.r + 1) mod (Array.length q.arr) in
      q.arr.(q.r) <- Some elem
  
  let dequeue q =
    if isEmpty q then ()
    else if q.r = q.f then
      let _ = q.r <- (-1) in
      q.f <- (-1)
    else
      q.f <- (q.f + 1) mod (Array.length q.arr)
    
  let first q =
    if isEmpty q then raise (Empty "Cannot call 'first' on an empty queue")
    else match q.arr.(q.f) with
        None -> raise Not_found 
      | Some(elem) -> elem

end;;
