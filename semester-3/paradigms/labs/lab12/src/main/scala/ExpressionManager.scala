import akka.actor._

object ExpressionManager {
  case class Evaluate(expr: ExpressionTree, evaluator: ActorRef)
  case class EvaluationResult(v: Double)

  def props = Props[ExpressionManager]
}

class ExpressionManager extends Actor {
  def receive = {
    case ExpressionManager.Evaluate(expr, evaluator) => {
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