trait Event

trait State {
  val transitions: Map[Event, State]
  def nextState(e: Event): State =
    transitions.get(e) match {
      case Some(state) => state
      case None => this
    }
}

class StateMachine(private var currState: State) {
  def state = currState

  def nextState(e: Event) =
    currState = currState.nextState(e)
}

object ToRed extends Event
object ToYellow extends Event
object ToGreen extends Event

object Green extends State {
  val transitions = Map(ToRed -> Red, ToYellow -> Yellow)

  override def toString = "Green"
}

object Yellow extends State {
  val transitions = Map(ToGreen -> Green, ToRed -> Red)

  override def toString = "Yellow"
}

object Red extends State {
  val transitions = Map[Event, State](ToGreen -> Green, ToYellow -> Yellow)

  override def toString = "Red"
}

class TrafficLight extends StateMachine(Red) {
  override def toString = state.toString
}


println("\nTests\n")

val light = new TrafficLight
println(light.toString)

light.nextState(ToYellow)
println(light.toString)

light.nextState(ToGreen)
println(light.toString)

light.nextState(ToYellow)
println(light.toString)

light.nextState(ToRed)
println(light.toString)

light.nextState(ToRed)
println(light.toString)

println("\nEnd of tests\n")