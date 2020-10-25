import akka.actor._

object Player {
  case object Stop
  case class Start(actor: ActorRef, initCount: Int)
  case class PassBall(count: Int)

  def props(name: String, sound: String) = Props(classOf[Player], name, sound)
}

class Player(val name: String, val sound: String) extends Actor {
  def receive = {
    case Player.PassBall(count: Int) => {
      if (count <= 1) {
        sender ! Player.Stop
        context.stop(self)
      } else {
        println(s"Player $name: $sound")
        sender ! Player.PassBall(count - 1)
      }

    }
    case Player.Start(actor: ActorRef, initCount: Int) => {
      println("Starting the game")
      actor ! Player.PassBall(initCount)
    }
    case Player.Stop => context.stop(self)
  }
}