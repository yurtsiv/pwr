// Task 1
def iterate[A](pred: (Int) => Boolean, func: (Int) => A): List[A] = {
  def iter(count: Int, acc: List[A]): List[A] = {
    if (pred(count)) iter(count + 1, func(count)::acc)
    else acc.reverse
  }

  iter(0, Nil)
}

// Task 2 A
def init[A](func: (Int) => A, n: Int): List[A] =
  iterate(i => i < n, func)


// Task 2 B
def integral(func: (Double) => Double, a: Int, b: Int) = {
  def calc_area(x1: Int, x2: Int): Double =
    (func(x1) + func(x2)) / 2

  val sum_parts = init(i => calc_area(a + i, a + i + 1), b - a)

  sum_parts.sum 
}

println("Task #1 (iterate)")
iterate(i => i < 10, i => i)
iterate(i => i < 0, i => i)
iterate(i => i < -10, i => i)

println("Task #2 A (init)")
init(i => i + 1, 10)
init(i => i + 1, 0)
init(i => i + 1, -10)

println("Task #2 B (integral)")
val quadratic = (x: Double) => x * x
integral(quadratic, 0, 4)
integral(quadratic, 0, 0)
integral(quadratic, -2, 0)

