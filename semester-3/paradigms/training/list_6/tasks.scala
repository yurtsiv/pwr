// Task 1
def whileLoop(pred: () => Boolean, func: () => Unit): Unit =
  if (pred()) {
    func()
    whileLoop(pred, func)
  } else ()
