import akka.actor._

object Main extends App {
  val actorSystem = ActorSystem("PingPongSystem")

  val player1: ActorRef = actorSystem.actorOf(Player.props("1", "Ping"))
  val player2: ActorRef = actorSystem.actorOf(Player.props("2", "Pong"))

  player2 ! Player.Start(player1, 10)
}