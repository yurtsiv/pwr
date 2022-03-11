import akka.actor._
import scala.collection.mutable.Map


object ExpressionEvaluator {
  case object DivisionByZero
  case object EvaluatorIdle

  case class Evaluate(expr: ExpressionTree)
  case class EvaluateExprArg(arg: ExpressionTree, argIndex: Int)
  case class ArgEvaluationRes(res: Double, argIndex: Int)


  def props = Props[ExpressionEvaluator]
}

class ExpressionEvaluator extends Actor {
  private var isRootEvaluator = false
  private var isEvaluating = false
  private var evaluatedArgs: Map[Int, Double] = Map()
  private var currentExpr: ExpressionTree = null
  private var currArgIndex = 0
  private var requester: ActorRef = null

  private def spawnChildrenToEvalArgs(arg1: ExpressionTree, arg2: ExpressionTree) = {
    val evaluator1 = context.actorOf(ExpressionEvaluator.props)
    val evaluator2 = context.actorOf(ExpressionEvaluator.props)

    evaluator1 ! ExpressionEvaluator.EvaluateExprArg(arg1, 0)
    evaluator2 ! ExpressionEvaluator.EvaluateExprArg(arg2, 1)
  }

  private def evalCompoundExpr(expr: ExpressionTree) = {
    expr match {
      case Sum(arg1, arg2) => spawnChildrenToEvalArgs(arg1, arg2)
      case Sub(arg1, arg2) => spawnChildrenToEvalArgs(arg1, arg2)
      case Mul(arg1, arg2) => spawnChildrenToEvalArgs(arg1, arg2)
      case Div(arg1, arg2) => spawnChildrenToEvalArgs(arg1, arg2)
    }
  }

  private def evalExpr(expr:ExpressionTree) = {
    expr match {
      case Val(v) => sendOperatorEvalRes(v)
      case _ => evalCompoundExpr(expr)
    }
  }

  private def sendOperatorEvalRes(res: Double) = {
    if (isRootEvaluator) {
      isEvaluating = false
      requester ! ExpressionManager.EvaluationResult(res)
    } else {
      requester ! ExpressionEvaluator.ArgEvaluationRes(res, currArgIndex)
    }
  }

  private def evalOperator(arg1: Double, arg2: Double) = {
    currentExpr match {
      case Sum(_, _) => sendOperatorEvalRes(arg1 + arg2)
      case Sub(_, _) => sendOperatorEvalRes(arg1 - arg2)
      case Mul(_, _) => sendOperatorEvalRes(arg1 * arg2)
      case Div(_, _) => {
        if (arg2 == 0) {
          requester ! ExpressionEvaluator.DivisionByZero
          isEvaluating = false
        } else {
          sendOperatorEvalRes(arg1 / arg2)
        }
      }
    }
  }

  def receive = {
    case ExpressionEvaluator.Evaluate(expr) => {
      if (isEvaluating) {
        sender ! ExpressionEvaluator.EvaluatorIdle
      } else {
        isEvaluating = true
        isRootEvaluator = true
        requester = sender
        currentExpr = expr
        evaluatedArgs = Map()
        evalExpr(expr) 
      }
    }

    case ExpressionEvaluator.EvaluateExprArg(arg, index) => {
      requester = sender
      currentExpr = arg
      currArgIndex = index
      evalExpr(arg)
    }

    case ExpressionEvaluator.DivisionByZero => {
      requester ! ExpressionEvaluator.DivisionByZero
    }

    case ExpressionEvaluator.ArgEvaluationRes(res, argIndex) => {
      context.stop(sender)
      evaluatedArgs += (argIndex -> res)

      if (evaluatedArgs.contains(0) && evaluatedArgs.contains(1)) {
        evalOperator(evaluatedArgs(0), evaluatedArgs(1))
      }
    }
  }
}