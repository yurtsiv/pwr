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
    val seq = iterate(List(n-1), (acc: List[Int]) => acc.head > 0, (acc: List[Int]) => (acc.head - 1)::acc)
    seq.map(func)
  }
}


// Task 2 B
def integral(func: (Double) => Double, a: Double, b: Double, n: Int): Double = {
  val dx = (b - a) / n
  val func_vals = init(i => func(a + dx * i), n + 1)
  def calc_areas(acc: List[Double], vals: List[Double]): List[Double] =
    vals match {
      case Nil | List(_) => acc
      case hd1::hd2::tail => {
        val area = ((hd1 + hd2) / 2) * dx
        calc_areas(area::acc, hd2::tail)
      }
    }

  calc_areas(Nil, func_vals).sum
}

println("Task #1 (iterate)")
iterate(0, (n: Int) => n < 10, (n: Int) => n + 1)

println("Task #2 A (init)")
init(i => i + 1, 10)
init(i => i + 1, 0)
init(i => i + 1, -10)

println("Task #2 B (integral)")
integral(x => x, 0, 1, 10)
integral(x => x, 1, 0, 10)
integral(x => x, 0, 0, 10)

integral(Math.sin, 0, Math.PI, 1000)
