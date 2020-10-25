// Task 2
def curry3[A, B, C, D](func: (A, B, C) => D) =
  (x: A) => (y: B) => (z: C) => func(x, y, z)

def uncurry3[A, B, C, D](func: (A) => (B) => (C) => D) =
  (x: A, y: B, z: C) => func(x)(y)(z)

// Task 3
def sumProd(xs: List[Int]): (Int, Int) =
  xs.foldLeft((0, 1))(
    (acc, next) => (acc._1 + next, acc._2 * next)
  )

// Task 5 a
def insertionsort[A](comp: (A, A) => Boolean, xs: List[A]): List[A] = {
  def insert(elem: A, l: List[A]): List[A] =
    l match {
      case Nil => List(elem)
      case hd::tail =>
        if (comp(hd, elem)) elem::l
        else hd::insert(elem, tail)
    }
  
  def iterate(acc: List[A], remaining: List[A]): List[A] =
    remaining match {
      case Nil => acc
      case hd::tail =>
        iterate(insert(hd, acc), tail)
    }
  
  iterate(List(), xs)
}

// Task 5 b
def merge[A](comp: (A, A) => Boolean, xs: List[A], ys: List[A]): List[A] =
  (xs, ys) match {
    case (Nil, _) => ys
    case (_, Nil) => xs
    case (hd1::tail1, hd2::tail2) =>
      if (comp(hd2, hd1)) hd1::merge(comp, tail1, ys)
      else hd2::merge(comp, xs, tail2)
  }

def mergesort[A](comp: (A, A) => Boolean, xs: List[A]): List[A] =
  xs match {
    case Nil => Nil
    case List(a) => List(a)
    case _ => {
      val halfLen = xs.length / 2
      val firs_half = xs.take(halfLen)
      val second_half = xs.drop(halfLen)

      merge(comp, mergesort(comp, firs_half), mergesort(comp, second_half))
    }
  }
