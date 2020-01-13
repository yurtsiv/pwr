import akka.actor._

object Main extends App {
  val actorSystem = ActorSystem("PingPongSystem")

  val player1: ActorRef = actorSystem.actorOf(Player.props("1"))
  val player2: ActorRef = actorSystem.actorOf(Player.props("2"))

  player1 ! Player.Start(player2)
}