import akka.actor._

object ExpressionEvaluator {
  case object DivisionByZero
  case class Evaluate(expr: ExpressionTree)
  case class EvaluationResult(v: Double)

  case class EvaluateExprArg(arg: ExpressionTree, argIndex: Int)
  case class ArgEvaluationRes(res: Double, argIndex: Int)

  def props = Props[ExpressionEvaluator]
}

class ExpressionEvaluator extends Actor {
  private var evaluatedArg = 0;
  private var oneArgEvaluated = false;
  private var currentExpr: ExpressionTree;

  // TODO: refactor repetitive code
  def evalExpr = {
    case Val(v) => {
      sender ! EvaluationResult(v)
    }
    case Sum(arg1, arg2) => {
      val evaluator1 = context.actorOf(ExpressionEvaluator)
      val evaluator2 = context.actorOf(ExpressionEvaluator)

      evaluator1 ! EvaluateExprArg(arg1, 0)
      evaluator1 ! EvaluateExprArg(arg2, 1)
    }
    case Sub(arg1, arg2) => {
      val evaluator1 = context.actorOf(ExpressionEvaluator)
      val evaluator2 = context.actorOf(ExpressionEvaluator)

      evaluator1 ! EvaluateExprArg(arg1, 0)
      evaluator1 ! EvaluateExprArg(arg2, 1)
    }
    case Mul(arg1, arg2) => {
      val evaluator1 = context.actorOf(ExpressionEvaluator)
      val evaluator2 = context.actorOf(ExpressionEvaluator)

      evaluator1 ! EvaluateExprArg(arg1, 0)
      evaluator1 ! EvaluateExprArg(arg2, 1)
    }
    case Div(arg1, arg2) => {
      val evaluator1 = context.actorOf(ExpressionEvaluator)
      val evaluator2 = context.actorOf(ExpressionEvaluator)

      evaluator1 ! EvaluateExprArg(arg1, 0)
      evaluator1 ! EvaluateExprArg(arg2, 1)
    }
  }

  // TODO: refactor repetitive code
  def evalExprArg(expr: ExpressionTree, argIndex: Int) = {
    expr match {
      case Sum(arg1, arg2) => {
        val evaluator1 = context.actorOf(ExpressionEvaluator)
        val evaluator2 = context.actorOf(ExpressionEvaluator)

        evaluator1 ! EvaluateExprArg(arg1, 0)
        evaluator1 ! EvaluateExprArg(arg2, 1)
      }
      case Sub(arg1, arg2) => {
        val evaluator1 = context.actorOf(ExpressionEvaluator)
        val evaluator2 = context.actorOf(ExpressionEvaluator)

        evaluator1 ! EvaluateExprArg(arg1, 0)
        evaluator1 ! EvaluateExprArg(arg2, 1)
      }
      case Mul(arg1, arg2) => {
        val evaluator1 = context.actorOf(ExpressionEvaluator)
        val evaluator2 = context.actorOf(ExpressionEvaluator)

        evaluator1 ! EvaluateExprArg(arg1, 0)
        evaluator1 ! EvaluateExprArg(arg2, 1)
      }
      case Div(arg1, arg2) => {
        val evaluator1 = context.actorOf(ExpressionEvaluator)
        val evaluator2 = context.actorOf(ExpressionEvaluator)

        evaluator1 ! EvaluateExprArg(arg1, 0)
        evaluator1 ! EvaluateExprArg(arg2, 1)
      }
    }
  }

  def evalOperator(arg1: Double, arg2: Double) = {
    currentExpr match {
      Sum(_, _) => sender ! EvaluationResult(arg1 + arg2)
      Sub(_, _) => sender ! EvaluationResult(arg1 - arg2)
      Mul(_, _) => sender ! EvaluationResult(arg1 * arg2)
      Div(_, _) => {
        if (arg2 == 0) {
          sender ! DivisionByZero
        } else {
          sender ! EvaluationResult(arg1 / arg2)
        }
      }
    }

  }

  def receive = {
    case Evaluate(expr) => {
      currentExpr = expr
      evalExpr(expr) 
    }
    case EvaluationResult(v) => {
      sender ! EvaluationResult(v)
    }
    case EvaluateExprArg(arg, argIndex) => {
      evalExprArg(arg, argIndex)
    }
    case DivisionByZero => {
      sender ! DivisionByZero
    }
    case ArgEvaluationRes(res, argIndex) => {
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