// Task #1
def get_nth[A, B, C](tuple: (A, B, C), elem: Int) = {
  val (a, b, c) = tuple;
  if (elem == 1) {
    a
  } else if (elem == 2) {
    b
  } else {
    c
  }
}

// Task #2
def sum_and_mul(s: Int, e: Int) = {
  def aux(n: Int, acc: (Int, Int)): (Int, Int) = {
    val (sum, mul) = acc
    if (n >= e) {
      acc
    } else {
      aux(n+1, (sum + n, mul * n))
    }
  }

  aux(s, (0, 1))
}

// Task #3
def merge[A](list1: List[A], list2: List[A]): List[A] = {
  if (list1.length == 0) {
    list2
  } else if (list2.length == 0) {
    list1
  } else {
    list1.head::list2.head::(merge(list1.tail, list2.tail))
  }
}

// Task #4
def is_prime(num: Int): Boolean = {
  def check_is_prime(num: Int, nextDivisor: Int): Boolean = {
    if (num == nextDivisor) {
      true
    } else if (num <= 1 || (num % nextDivisor) == 0) {
      false
    } else {
      check_is_prime(num, nextDivisor + 1)
    }
  }

  check_is_prime(num, 2)
}

println("Task #1")
get_nth((1, 'a', 2.1), 1)
get_nth((1, 'a', 2.1), 2)
get_nth((1, 'a', 2.1), 3)

println("Task #2")
sum_and_mul(1, 5)
sum_and_mul(1, 1)
sum_and_mul(-4, 4)

println("Task #3")
merge(List(1, 2), List(3, 4))
merge(List(1,2), List(3, 4, 5, 6, 7, 8))
merge(List(1,2,3,4,5), List(6,7))

println("Task #4")
is_prime(5)
is_prime(4)
is_prime(0)
is_prime(1)
is_prime(-1)
