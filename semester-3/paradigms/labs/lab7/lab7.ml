module type ORDERED_LIST =
  sig
    type element
    type t

    val empty: unit -> t
    val length: t -> int
    val insert: (element * t) -> t
    val remove: (int * t) -> t
    val getNth: (int * t) -> element option
    val toList: t -> element list
  end

module type ORDERED =
  sig
    type t

    val lowerEqual: t -> t -> bool
  end

module OrderedList(Ordered: ORDERED): ORDERED_LIST with type element = Ordered.t =
  struct
    type element = Ordered.t
    type t = int * element list

    let rec insert_elem pred elem = function
    | [] -> [elem]
    | hd::tail as l ->
      if pred elem hd
      then elem::l
      else hd::(insert_elem pred elem tail)

    let empty () = (0, [])

    let length (len, _) = len

    let insert (elem, (len, list)) =
      (len + 1, (insert_elem Ordered.lowerEqual elem list))

    let remove (index, ((len, list)as l)) =
      let rec remove_help count (hd::tail) =
        if count == index then tail
        else hd::(remove_help (count + 1) tail)
      in
        if len == 0 then l
        else if (index < 0 or index >= len) then l
        else ((len - 1), remove_help 0 list)

    let rec getNth (index, (len, list)) =
      match list with
        [] -> None
      | hd::tail ->
        if index = 0 then Some(hd)
        else getNth((index - 1), (len - 1, tail))

    let toList (_, list) = list
  end

module IntAscOrder: ORDERED with type t = int =
  struct
    type t = int

    let lowerEqual = (<=)
  end
;;

module OrderedIntList = OrderedList(IntAscOrder);;

let l = OrderedIntList.(insert (10, insert (2, insert (5, insert (7, empty ())))));;
   
OrderedIntList.toList l;;
OrderedIntList.length l;;
OrderedIntList.(toList (remove (-1, l)));;
OrderedIntList.(toList (remove (100, l)));;
OrderedIntList.(toList (remove (0, empty ())));;
OrderedIntList.(toList (remove (2, l)));;
OrderedIntList.getNth (100, l);;
OrderedIntList.getNth (0, l);;
