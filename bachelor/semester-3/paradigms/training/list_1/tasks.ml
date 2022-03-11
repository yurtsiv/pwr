let rec flatten xs =
  if xs = [] then []
  else List.append (List.hd xs) (flatten (List.tl xs))

let rec count (elem, xs) =
  if xs = [] then 0
  else (if (List.hd) xs = elem then 0 else 1) + count (elem, List.tl xs)

let rec replicate (elem, count) =
  if count = 1 then [elem]
  else elem::replicate (elem, count - 1)

let rec sqrList xs =
  if xs = [] then []
  else ((List.hd xs) * List.hd(xs))::sqrList (List.tl xs)

let reverse xs =
  let rec reverse_help acc list =
    if list = [] then acc
    else reverse_help ((List.hd list)::acc) (List.tl list)
  in reverse_help [] xs

let palindrome list =
  list = reverse list

let rec listLength xs =
  if xs = [] then 0
  else 1 + listLength (List.tl xs)
