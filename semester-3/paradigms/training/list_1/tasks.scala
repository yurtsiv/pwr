object Tasks {
    def flatten(xs: List[List[Int]]): List[Int] =
        if (xs == Nil) Nil else xs.head ++ flatten(xs.tail)

    def count[A](elem: A, xs: List[A]): Int =
        if (xs == Nil) 0
        else (if (xs.head == elem) 1 else 0) + count(elem, xs.tail) 

    def replicate[A](elem: A, count: Int): List[A] =
        if (count == 1) List(elem)
        else elem::replicate(elem, count-1)

    def sqrList(xs: List[Int]): List[Int] =
        if (xs == Nil) Nil
        else (xs.head * xs.head)::sqrList(xs.tail)

    def palindrome[A](xs: List[A]): Boolean = xs == xs.reverse

    def listLength[A](xs: List[A]): Int =
        if (xs == Nil) 0
        else 1 + listLength(xs.tail) 
}