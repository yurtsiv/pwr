let rec flatten = function
  | [] -> []
  | hd :: tail -> List.append hd (flatten tail)

let rec count (elem, list) =
  match list with
  | [] -> 0
  | hd :: tail ->
    if hd = elem then 1 + count (elem, tail)
    else count (elem, tail)


let rec replicate (elem, count) =
  if count = 1 then [elem]
  else elem :: replicate (elem, count - 1)


let rec sqrList list =
  match list with
  | [] -> []
  | hd :: tail ->
    let squared = (float_of_int hd) ** 2. |> int_of_float
    in squared :: sqrList tail


let reverse list =
  let rec aux acc = function
    | [] -> acc 
    | hd::tail -> aux (hd::acc) tail in
  aux [] list


let palindrome list =
  list = reverse list

let rec listLength = function
  | [] -> 0
  | hd :: tail -> 1 + listLength tail

