object Tasks {
    def flatten(list: List[List[Int]]): List[Int] = list match {
        case List() => List() 
        case hd :: tail => hd ++ flatten(tail)
    }

    def count[A](elem: A, list: List[A]): Int = list match {
        case List() => 0
        case hd :: tail =>
            if (hd == elem) 1 + count(elem, tail) else count(elem, tail) 
    }

    def replicate[A](elem: A, count: Int): List[A] = count match {
        case 1 => List(elem)
        case _ => elem :: replicate(elem, count - 1)
    }

    def sqrList(list: List[Int]): List[Int] = list match {
        case List() => List()
        case hd :: tail => {
            val squared = Math.pow(hd, 2).toInt;
            squared :: sqrList(tail)
        }
    }

    def palindrome[A](list: List[A]): Boolean = list == list.reverse

    def listLength[A](list: List[A]): Int = list match {
        case List() => 0
        case hd :: tail => 1 + listLength(tail)
    }
}