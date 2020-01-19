import akka.actor._

object ExpressionEvaluator {
  case object DivisionByZero
  case class Evaluate(expr: ExpressionTree)

  case class EvaluateExprArg(arg: ExpressionTree, argIndex: Int)
  case class ArgEvaluationRes(res: Double, argIndex: Int)

  def props = Props[ExpressionEvaluator]
}

class ExpressionEvaluator extends Actor {
  var evaluatedArg = 0.0
  var oneArgEvaluated = false
  var currentExpr: ExpressionTree = Val(0.0)
  var requester: ActorRef = null
  var isRootEvaluator = false
  var argIndex = 0

  def spawnChildren(arg1: ExpressionTree, arg2: ExpressionTree) = {
    val evaluator1 = context.actorOf(ExpressionEvaluator.props)
    val evaluator2 = context.actorOf(ExpressionEvaluator.props)

    evaluator1 ! ExpressionEvaluator.EvaluateExprArg(arg1, 0)
    evaluator2 ! ExpressionEvaluator.EvaluateExprArg(arg2, 1)
  }

  def evalCompoundExpr(expr: ExpressionTree) = {
    expr match {
      case Sum(arg1, arg2) => spawnChildren(arg1, arg2)
      case Sub(arg1, arg2) => spawnChildren(arg1, arg2)
      case Mul(arg1, arg2) => spawnChildren(arg1, arg2)
      case Div(arg1, arg2) => spawnChildren(arg1, arg2)
    }
  }

  def evalExpr(expr:ExpressionTree) = {
    expr match {
      case Val(v) => {
        requester ! ExpressionManager.EvaluationResult(v)
      }
      case _ => evalCompoundExpr(expr)
    }
  }

  def evalExprArg(expr: ExpressionTree, argIndex: Int) = {
    expr match {
      case Val(v) => {
        requester ! ExpressionEvaluator.ArgEvaluationRes(v, argIndex)
      }
      case _ => evalCompoundExpr(expr)
    }
  }

  def sendOperatorEvalRes(res: Double) = {
    if (isRootEvaluator) {
      requester ! ExpressionManager.EvaluationResult(res)
    } else {
      requester ! ExpressionEvaluator.ArgEvaluationRes(res, argIndex)
    }
  }

  def evalOperator(arg1: Double, arg2: Double) = {
    currentExpr match {
      case Sum(_, _) => sendOperatorEvalRes(arg1 + arg2)
      case Sub(_, _) => sendOperatorEvalRes(arg1 - arg2)
      case Mul(_, _) => sendOperatorEvalRes(arg1 * arg2)
      case Div(_, _) => {
        if (arg2 == 0) {
          requester ! ExpressionEvaluator.DivisionByZero
        } else {
          sendOperatorEvalRes(arg1 / arg2)
        }
      }
    }
  }

  def receive = {
    case ExpressionEvaluator.Evaluate(expr) => {
      println(s"Evaluator: Requested to evaluate $expr from $sender")
      isRootEvaluator = true
      requester = sender
      currentExpr = expr
      evalExpr(expr) 
    }
    case ExpressionEvaluator.EvaluateExprArg(arg, index) => {
      println(s"Evaluator: Requested to evaluate argument $arg")
      requester = sender
      currentExpr = arg
      argIndex = index
      evalExprArg(arg, index)
    }
    case ExpressionEvaluator.DivisionByZero => {
      requester ! ExpressionEvaluator.DivisionByZero
    }
    case ExpressionEvaluator.ArgEvaluationRes(res, argIndex) => {
      println(s"Evaluator: Argument $argIndex evaluated: $res (from $sender)")
      context.stop(sender)


      if (oneArgEvaluated) {
        if (argIndex == 0) {
          evalOperator(res, evaluatedArg)
        } else {
          evalOperator(evaluatedArg, res)
        }
      } else {
        oneArgEvaluated = true;
        evaluatedArg = res;
      }
    }
  }
}