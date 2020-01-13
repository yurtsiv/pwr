import akka.actor._

object Player {
  case object Ping
  case object Pong
  case class Start(actor: ActorRef)

  def props(name: String) = Props(classOf[Player], name)
}

class Player(val name: String) extends Actor {
  def receive = {
    case Player.Ping => {
      println(s"Player $name: Ping")
      sender ! Player.Pong
    }
    case Player.Pong => {
      println(s"Player $name: Pong")
      sender ! Player.Ping
    }
    case Player.Start(actor: ActorRef) => actor ! Player.Ping
  }
}