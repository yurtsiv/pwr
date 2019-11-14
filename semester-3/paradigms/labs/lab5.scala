// Task 2
def combine[A](l1: LazyList[A], l2: LazyList[A], combine_elems: (A, A) => A): LazyList[A] =
  (l1, l2) match {
    case (LazyList(), _) => l2
    case (_, LazyList()) => l1
    case (hd1#::tail1, hd2#::tail2) =>
      combine_elems(hd1, hd2)#::combine(tail1, tail2, combine_elems)
  }

println("Task 2")
val add = (x: Int, y: Int) => x + y

combine(LazyList.from(0), LazyList.from(1), add)
  .take(10)
  .toList

combine(LazyList(), LazyList.from(1), add)
  .take(10)
  .toList

combine(LazyList.from(1), LazyList(), add)
  .take(10)
  .toList

combine(LazyList(), LazyList(), add)
  .take(10)
  .toList

