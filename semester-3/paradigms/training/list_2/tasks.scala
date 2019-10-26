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
}