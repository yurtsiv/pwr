module type ORDERED_LIST =
  sig
    type element
    type t

    val empty: unit -> t
    val length: t -> int
    val insert: element -> t -> t
    val remove: int -> t -> t
    val getNth: int -> t -> Option element
    val toList: t -> element list
  end

module type ORDERED =
  sig
    type t

    val lowerEqual: t -> t -> bool
  end

module IntAscOrder: ORDERED with type t = int =
  struct
    type t = int

    let lowerEqual = (<=)
  end

module OrderedList(Ordered: ORDERED): ORDERED_LIST =
  struct
    type element = Ordered.t
    type t = OrderedList of int * Ordered.t list


    let empty () = OrderedList(0, [])

    let length (OrderedList(len, _)) = len

    let insert elem (OrderedList(len, list)) =
      OrderedList(len + 1, elem::list)

    let remove index l = l

    let getNth index (OrderedList(_, list)) =
      let getNthHelp count = function
        [] -> None
      | hd::tail ->
        if count == index then Some(hd) 
        else getNthHelp (count + 1) tail
      in getNthHelp 0 list

    let toList (OrderedList(_, list)) = list
  end
