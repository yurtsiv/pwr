sealed trait Expr
case class Val(v: Double) extends Expr
case object Sum extends Expr
case object Diff extends Expr
case object Prod extends Expr
case object Div extends Expr

def calcSum(stack: List[Option[Double]]): List[Option[Double]] = {
  stack match {
    case Nil | List(_) => List(None)
    case Some(v1)::Some(v2)::tail =>
      Some(v1 + v2)::tail
    case _ => List(None)
  }
}

def evaluate(expr: List[Expr]): List[Option[Double]] = {
  expr.foldLeft(List())((acc, currExpr) => {
    currExpr match {
      case Val(v) => Some(v)::acc
      case Sum => calcSum(acc)
    }
  });
}