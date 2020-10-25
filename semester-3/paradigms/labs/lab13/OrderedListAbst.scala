abstract class OrderedListAbst {
  type T
  private var list: List[T] = List() 

  def insert(elem: T)(implicit ordering: Ordering[T]) = {
    def insert_in_order(l: List[T]): List[T] = {
      l match {
        case Nil => List(elem)
        case hd::tail => {
          if (ordering.compare(hd, elem) > 0) {
            elem::hd::tail
          } else {
            hd::(insert_in_order(tail))
          }
        }
      }
    }

    list = insert_in_order(list)
  }

  def length = list.size

  def contains(elem: T) = list.contains(elem)

  def remove(n: Int) = {
    if (n < 0 || n >= length) {
      throw new IllegalArgumentException("Wrong index")
    }

    def remove_help(count: Int, l: List[T]): List[T] = {
      val hd::tail = l
      if (count == n) {
        tail
      } else {
        hd::remove_help(count + 1, tail)
      }
    }

    list = remove_help(0, list)
  }

  def toList = list

  override def toString = {
    val elems = list.foldLeft("")((s, e) => s"$s $e, ")
    s"[$elems]"
  }
}

println("\n\nTests\n\n")

println("List of ints\n")
val intList = new OrderedListAbst { type T = Int }
println("Adding 3, 5, 2, 4, 1")
intList.insert(3)
intList.insert(5)
intList.insert(2)
intList.insert(4)
intList.insert(1)

println(s"To list: $intList")
println(s"Length: ${intList.length}")
println(s"Contains 3: ${intList.contains(3)}")
println(s"Contains 10: ${intList.contains(10)}")

println("Removing at 0 & 3:")
intList.remove(0)
intList.remove(3)

println(s"To list: $intList")

println("Removing at -1: ")
try {
  intList.remove(-1)
} catch {
  case e: Exception => println(e)
}

println("Removing at 10: ")
try {
  intList.remove(10)
} catch {
  case e: Exception => println(e)
}

println("\nList of strings\n")
val strList = new OrderedListAbst { type T = String }
println("Adding B, D, A, C, E")
strList.insert("B")
strList.insert("D")
strList.insert("A")
strList.insert("C")
strList.insert("E")

println(s"To list: $strList")
println(s"Length: ${strList.length}")
println(s"Contains C: ${strList.contains("C")}")
println(s"Contains H: ${strList.contains("H")}")

println("Removing at 0 & 3:")
strList.remove(0)
strList.remove(3)

println(s"To list: $strList")

println("Removing at -1: ")
try {
  strList.remove(-1)
} catch {
  case e: Exception => println(e)
}

println("Removing at 10: ")
try {
  strList.remove(10)
} catch {
  case e: Exception => println(e)
}
