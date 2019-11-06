// Task 1
def iterate[A](init: A, pred: (A) => Boolean, func: (A) => A): A = {
  def iter(acc: A): A =
    if (pred(acc)) iter(func(acc))
    else acc

  iter(init)
}

// Task 2 A
def init[A](func: (Int) => A, n: Int): List[A] = {
  if (n < 0) Nil
  else {
    val seq = iterate(List(n-1), acc => acc.head > 0), acc => (acc.head - 1)::acc))
    seq.map(func)
  }
}


// Task 2 B
def integral(func: (Double) => Double, a: Int, b: Int) = {
  def calc_area(x1: Int, x2: Int): Double =
    (func(x1) + func(x2)) / 2

  val sum_parts = init(i => calc_area(a + i, a + i + 1), b - a)

  sum_parts.sum 
}

println("Task #1 (iterate)")
iterate(0, (n) => n < 10, (n) => n + 1)

println("Task #2 A (init)")
init(i => i + 1, 10)
init(i => i + 1, 0)
init(i => i + 1, -10)

println("Task #2 B (integral)")
val quadratic = (x: Double) => x * x
integral(quadratic, 0, 4)
integral(quadratic, 0, 0)
integral(quadratic, -2, 0)

