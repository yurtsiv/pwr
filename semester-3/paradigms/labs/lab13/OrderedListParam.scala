class OrderedListParam[T](implicit ordering: Ordering[T]) {
  private var list: List[T] = List() 

  def insert(elem: T) = {
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