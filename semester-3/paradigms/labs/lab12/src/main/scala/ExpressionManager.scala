import akka.actor._

object ExpressionManager {
  case class Evaluate(expr: ExpressionTree)
  case class EvaluationResult(v: Double)

  def props(evaluator: ActorRef) = Props(classOf[ExpressionManager], evaluator)
}

class ExpressionManager(val evaluator: ActorRef) extends Actor {
  def receive = {
    case ExpressionManager.Evaluate(expr) => {
      evaluator ! ExpressionEvaluator.Evaluate(expr)
    }
    case ExpressionManager.EvaluationResult(v) => {
      println(s"Result: $v")
    }
    case ExpressionEvaluator.DivisionByZero => {
      println("Division by zero")
    }
    case ExpressionEvaluator.EvaluatorIdle => {
      println("Evaluator is idle at the moment")
    }
  }
}