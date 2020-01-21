class OrderedListParam[T](implicit order: (T, T) => Ordered[T]) {
  private var list: List[T] = List() 

  def insert(elem: T) = {
    def ordered_insert(l: List[T]): List[T] = {
      l match {
        case List() => List(elem)
        case hd::tail => {
          if (order(elem, hd)) {
            elem::hd::tail
          } else {
            hd::(ordered_insert(tail))
          }
        }
      }
    }

    list = ordered_insert(list)
  }

  def length = list.size

  def contains(elem: T) = list.contains(elem)

  def remove(n: Int) = {
    if (n < 0 || n >= length) {
      throw new IllegalArgumentException("Wrong index")
    }

    list.zipWithIndex.filter(_._1 != n).map(_._2)
  }

  def toList = list

  override def toString = s"$list"
}