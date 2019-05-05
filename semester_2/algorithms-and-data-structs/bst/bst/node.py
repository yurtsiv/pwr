class Node:
  id, key, left, right, parent = None, None, None, None, None

  def __init__(self, id, key):
    self.id = id
    self.key = key

  def _find_relative_side(self):
    if not self.parent:
      return None

    if self.parent.left and self.parent.left.id == self.id:
      return 'left'
    
    return 'right'

  def substitute_with_child(self, child_side):
    side = self._find_relative_side()
    if not side:
      return

    setattr(self.parent, side, getattr(self, child_side))
  
  def substitute_with(self, node):
    side = self._find_relative_side()
    if not side:
      return

    setattr(self.parent, side, node) 