import akka.actor._

object Main extends App {
  val actorSystem = ActorSystem("ExpressionEvaluator")

  val evaluator: ActorRef = actorSystem.actorOf(ExpressionEvaluator.props)
  val manager: ActorRef = actorSystem.actorOf(ExpressionManager.props)

  val expr = Sum(Div(Val(6), Val(3)), Val(3))
  manager ! ExpressionManager.Evaluate(expr, evaluator)
}