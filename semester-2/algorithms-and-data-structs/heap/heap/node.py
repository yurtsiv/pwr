class Node:
  def __init__(self, id, key):
    self.id = id
    self.key = key
    self.right = self.left = self.parent = None

  def find_relative_side(self):
    if not self.parent:
      return None

    if self.parent.left and self.parent.left.id == self.id:
      return 'left'
    
    return 'right'
  

  def substitute_with_parent(self):
    relative_side = self.find_relative_side()

    if self.right:
      self.right.parent = self.parent
    
    if self.left:
      self.left.parent = self.parent

    if relative_side == 'left':
      # modify parent's right child parent
      if self.parent.right:
        self.parent.right.parent = self

      # switch left sides
      self.parent.left = self.left
      self.left = self.parent

      # switch right sides 
      prev_self_right = self.right
      self.right = self.parent.right
      self.parent.right = prev_self_right
    else:
      # modify parent's left child parent
      if self.parent.left:
        self.parent.left.parent = self

      # switch right sides 
      self.parent.right = self.right
      self.right = self.parent

      # switch left sides
      prev_self_left = self.left
      self.left = self.parent.left
      self.parent.left = prev_self_left

    if self.parent.parent:
      # modify parent's parent to point to self
      parent_side = self.parent.find_relative_side()
      setattr(self.parent.parent, parent_side, self)

    prev_parent = self.parent
    # make grandpa your parent
    self.parent = self.parent.parent
    # make parent your child
    prev_parent.parent = self