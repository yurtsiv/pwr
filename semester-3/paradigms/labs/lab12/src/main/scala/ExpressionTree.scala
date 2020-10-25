sealed trait ExpressionTree
case class Val(v: Double) extends ExpressionTree
case class Sum(arg1: ExpressionTree, arg2: ExpressionTree) extends ExpressionTree
case class Sub(arg1: ExpressionTree, arg2: ExpressionTree) extends ExpressionTree
case class Mul(arg1: ExpressionTree, arg2: ExpressionTree) extends ExpressionTree
case class Div(arg1: ExpressionTree, arg2: ExpressionTree) extends ExpressionTree
