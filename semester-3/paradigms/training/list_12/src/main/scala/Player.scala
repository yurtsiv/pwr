import akka.actor._

object Player {
  case class Ping(count: Int)
  case class Pong(count: Int)
  case class Start(actor: ActorRef, initCount: Int)
  case object Stop

  def props(name: String) = Props(classOf[Player], name)
}

class Player(val name: String) extends Actor {
  def checkCount(count: Int) = {
    if (count == 1) {
      context.stop(self)
      sender ! Player.Stop
    }
  }

  def receive = {
    case Player.Ping(count) => {
      checkCount(count)
      println(s"Player $name: Pong. Count $count")
      sender ! Player.Pong(count -1)
    }
    case Player.Pong(count) => {
      checkCount(count)
      println(s"Player $name: Ping. Count $count")
      sender ! Player.Ping(count - 1)
    }
    case Player.Start(actor: ActorRef, initCount: Int) => {
      actor ! Player.Ping(initCount)
    }
    case Player.Stop => context.stop(self)
  }
}