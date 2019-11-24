sealed trait lBT[+A]
case object LEmpty extends lBT[Nothing]
case class LNode[+A](elem:A, left:()=>lBT[A], right:()=>lBT[A]) extends lBT[A]

// Task 1
def lrepeat[A](k: Int)(lxs: LazyList[A]): LazyList[A] = {
  def lrepeat_help(count: Int, lys: LazyList[A]): LazyList[A] =
    lys match {
      case LazyList() => LazyList()
      case hd#::tail => {
        if (count == 0) lrepeat_help(k, tail)
        else hd#::(lrepeat_help(count - 1, lys))
      }
    }
  
  lrepeat_help(k, lxs)
}

// Task 2
def lconstruct_fib (): LazyList[Int] = {
  def fib(a: Int, b: Int): LazyList[Int] = LazyList(a + b)#:::fib(b, a + b)

  LazyList(0, 1)#:::fib(0, 1)
}

val lfib = lconstruct_fib()

// Task 3 a
def lBreadth[A](ltree: lBT[A]): LazyList[A] = {
  def lBreadthHelp(queue: List[lBT[A]]): LazyList[A] =
    queue match {
      case Nil => LazyList()
      case LEmpty::tail => lBreadthHelp(tail)
      case LNode(root, lleft, lright)::tail =>
        LazyList(root)#:::lBreadthHelp(tail:::List(lleft(), lright()))
    }
  
  lBreadthHelp(List(ltree))
}

// Task 3 b
def lTree(n: Int): lBT[Int] =
  LNode(
    n,
    () => lTree(Math.pow(2, n).intValue),
    () => lTree(Math.pow(2, n).intValue + 1)
  )
