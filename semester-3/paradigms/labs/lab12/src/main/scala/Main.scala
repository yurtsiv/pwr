import akka.actor._

object Main extends App {
  val actorSystem = ActorSystem("ExpressionEvaluator")

  val evaluator: ActorRef = actorSystem.actorOf(ExpressionEvaluator.props)
  val manager: ActorRef = actorSystem.actorOf(ExpressionManager.props)

  val exprs = List(
    Val(1),              // 1
    Sum(Val(1), Val(2)), // 3
    Sub(Val(1), Val(2)), // -1
    Mul(Val(2), Val(3)), // 6
    Div(Val(6), Val(2)), // 3
    Div(Val(6), Val(0)), // DivisionByZero
    Div(Val(0), Val(6)), // 0
    Sum((Div(Val(6), Val(2))), Mul(Val(3), Sub(Val(6), Val(1)))) // (6 / 2) + (3 * (6 - 1)) = 18
  )

  for (expr <- exprs) {
    manager ! ExpressionManager.Evaluate(expr, evaluator)
    Thread.sleep(500)
  }

  actorSystem.shutdown
}