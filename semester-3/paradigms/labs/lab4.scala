// Task 1
sealed trait Expr
case class Val(v: Double) extends Expr
case object Sum extends Expr
case object Diff extends Expr
case object Prod extends Expr
case object Div extends Expr

type Stack = List[Option[Double]]

def twoArgOp(operation: (Double, Double) => Option[Double])(stack: Stack): Stack =
  stack match {
    case Nil | List(_) => List(None)
    case Some(v1)::Some(v2)::tail =>
      operation(v2, v1)::tail
    case _ => List(None)
  }

def calcSum = twoArgOp((v1: Double, v2: Double) => Some(v1 + v2))(_)

def calcDiff = twoArgOp((v1: Double, v2: Double) => Some(v1 - v2))(_)

def calcProd = twoArgOp((v1: Double, v2: Double) => Some(v1 * v2))(_)

def calcDiv = twoArgOp(
  (v1: Double, v2: Double) => {
    if (v2 == 0) None
    else Some(v1 / v2)
  }
)(_)

def evaluate(expr: List[Expr]): Option[Double] = {
  val result = expr.foldLeft(List[Option[Double]]())((acc, currExpr) =>
    currExpr match {
      case Val(v) => Some(v)::acc
      case Sum => calcSum(acc)
      case Diff => calcDiff(acc)
      case Prod => calcProd(acc)
      case Div => calcDiv(acc)
    }
  )

  result match {
    case List(v) => v
    case _ => None
  }
}

println("Task 1 (evaluate)")

println("((3 + 3) / 2) * 3 - 1")
evaluate(List(Val(3), Val(3), Sum, Val(2), Div, Val(3), Prod, Val(1), Diff))

println("1 / 0")
evaluate(List(Val(1), Val(0), Div))

println("+")
evaluate(List(Sum))

println("1 +")
evaluate(List(Val(1), Sum))

println("+ 1")
evaluate(List(Sum, Val(1)))

println("1 4 + 5")
evaluate(List(Val(1), Val(4), Val(5), Sum))

println("+ -")
evaluate(List(Sum, Diff))