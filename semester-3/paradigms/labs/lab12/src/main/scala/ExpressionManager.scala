import akka.actor._

object ExpressionManager {
  case class Evaluate(expr: ExpressionTree, evaluator: ActorRef)
  case class EvaluationResult(v: Double)

  def props = Props[ExpressionManager]
}

class ExpressionManager extends Actor {
  def receive = {
    case ExpressionManager.Evaluate(expr, evaluator) => {
      println(s"Manager: Evaluation request $expr")
      evaluator ! ExpressionEvaluator.Evaluate(expr)
    }
    case ExpressionManager.EvaluationResult(v) => {
      println(s"Manager: Expression evaluated $v")
    }
    case ExpressionEvaluator.DivisionByZero => {
      println(s"Whoops. Division by zero")
    }
  }
}