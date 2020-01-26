abstract class Tuple {
  type T
  var fst: T
  var snd: T

  override def toString = s"($fst, $snd)"
}

val o1 = new Tuple { type T = Int; var fst = 1; var snd = 2 } // Type: Tuple { type T = Int }
val o2 = new Tuple { type T = String; var fst = "A"; var snd = "B" } // Type: Tuple { type T = String }