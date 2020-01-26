class Tuple[T](var fst: T, var snd: T) {
  override def toString = s"($fst, $snd)"
}

val o1 = new Tuple[Int](1, 1) // Type: Tuple[Int]
val o2 = new Tuple[String]("A", "B") // Type: Tuple[String]