// Task 3
sealed trait BT[+A]
case object Empty extends BT[Nothing]
case class Node[+A](elem:A, left:BT[A], right:BT[A]) extends BT[A]

val tt = Node(1,
              Node(2,
                    Node(4,
                         Empty,
                         Empty
                    ),
                    Empty
                  ),
              Node(3,
                    Node(5,
                          Empty,
                          Node(6,
                                Empty,
                                Empty
                          )
                    ),
                    Empty
              )
          )

def breadthBT[A](tree: BT[A]): List[A] = {
  def visit(queue: List[BT[A]], res: List[A]): List[A] =
    queue match {
      case Nil => res
      case Empty::tail => visit(tail, res)
      case Node(root, left, right)::tail =>
        visit(tail:::List(left, right), root::res)
    }
  
  visit(List(tree), Nil).reverse
}