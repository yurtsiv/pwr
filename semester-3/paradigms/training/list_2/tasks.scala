// Task 1: Stack length = 1 (compile time optimization)


object Tasks {
  def fib(n: Int): Int =
    if (n == 0) 0
    else if (n == 1) 1
    else fib(n-1) + fib(n-2)

  def fibTail(n: Int): Int = {
    def fibHelp(prev2: Int, prev1: Int, count: Int): Int =
      if (count == 1) prev1
      else fibHelp(prev1, prev1 + prev2, count - 1)

    fibHelp(0, 1, n)
  }

  def isPreciseEnough(x: Double, a: Double): Boolean = {
    val epsilon = 1e-55
    Math.abs(Math.pow(x, 3) - a) <= epsilon * Math.abs(a)
  }

  def root3(num: Double): Double = {
    def root3Help(prevX: Double): Double =
      if (isPreciseEnough(prevX, num)) prevX
      else {
        val nextX = prevX + (num / (prevX * prevX) - prevX) / 3
        root3Help(nextX)
      }
    
    val initX = if (num <= 1) num else num / 3

    root3Help(initX)
  }

  def initSegment[A](xs1: List[A], xs2: List[A]): Boolean =
    (xs1, xs2) match {
      case (Nil, _) => true
      case (_, Nil) => false
      case (hd1::tail1, hd2::tail2) =>
        if (hd1 != hd2) false
        else initSegment(tail1, tail2)
    }
}

// Task 4
val List(_, _, x, _, _) = List(-2, -1, 0, 1, 2)
val List((_, _), (x, _)) = List((1,2), (0, 1))