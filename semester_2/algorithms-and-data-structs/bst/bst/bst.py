import uuid
from bst.node import Node
from bst.utils import * 

class BST:
  root = None
  size = 0 

  def __init__(self, root = None):
    self.root = root
    self.size = get_size(root)

  def root_key(self):
    if self.root:
      return self.root.key
    
    return None

  def add(self, key):
    node = Node(uuid.uuid4(), key)

    if not self.root:
      self.root = node 
      self.size += 1
      return True
    
    inserted = insert(self.root, node)
    if inserted:
      self.size += 1
    
    return inserted
    
  def remove(self, key):
    node_to_remove = find(self.root, key)
    if not node_to_remove:
      return False

    self.size -= 1

    # remove root
    if node_to_remove.id == self.root.id:
      if self.root.left:
        left_max = find_max(self.root.left)
        left_max.substitute_with_child('left')
        left_max.right = self.root.right
        left_max.left = self.root.left

        self.root = left_max
      else:
        self.root = self.root.right

      return True

    # remove node with only left child or no childs
    if not node_to_remove.right:
      node_to_remove.substitute_with_child('left')
      return True
    
    # remove node with only right child or no childs
    if not node_to_remove.left:
      node_to_remove.substitute_with_child('right')
      return True

    # remove node with both childs 
    left_max = find_max(node_to_remove.left)
    left_max.substitute_with_child('left')
    left_max.right = node_to_remove.right
    left_max.left = node_to_remove.left
    node_to_remove.substitute_with(left_max)
    return True

  def find(self, key):
    res = find(self.root, key)
    if res:
      return res.id
  
  def max(self):
    if not self.root:
      return

    return find_max(self.root).key
  
  def min(self):
    if not self.root:
      return

    return find_min(self.root).key
  
  def subtree(self, key):
    root = find(self.root, key)
    if root:
      return BST(root)
    
    return None


  def draw(self, canvas, init_pos):
    draw(
      self.root,
      None,
      init_pos,
      1,
      { 'canvas': canvas, 'tree_size': self.size }
    )
  
  def to_string(self):
    return {
      'in_order': traverse_in_order(self.root),
      'pre_order': traverse_pre_order(self.root),
      'post_order': traverse_post_order(self.root)
    }