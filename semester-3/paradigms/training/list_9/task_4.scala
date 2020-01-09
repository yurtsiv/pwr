class UzycieWyjatkow {
  def main(args: Array[String]): Unit =
    try {
      metoda1
    } catch {
      case e: Exception => {
        System.err.println(e.getMessage)
        e.printStackTrace
      }
    }

  def metoda1 = metoda2
  def metoda2 = metoda3
  def metoda3 =
    throw new Exception("Wyjatek zgloszony z metoda3")

}

// Wyjatek zgloszony z metoda3
// java.lang.Exception: Wyjatek zgloszony z metoda3
// 	at $line124.$read$$iw$$iw$UzycieWyjatkow.metoda3(task_4.scala:7)
// 	at $line124.$read$$iw$$iw$UzycieWyjatkow.metoda2(task_4.scala:4)
// 	at $line124.$read$$iw$$iw$UzycieWyjatkow.metoda1(task_4.scala:2)
// 	at $line124.$read$$iw$$iw$UzycieWyjatkow.main(task_4.scala:11)
