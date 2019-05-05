from tkinter import *

class BSTCanvas:
  def __init__(self, master, root):
    self.canvas = Canvas(root, bg="#fff")
    self.canvas.pack(fill=BOTH, expand=1)

  def draw(self, bst):
    self.canvas.delete('all')
    bst.draw(
      self.canvas,
      {
        'x': self.canvas.winfo_width() // 2,
        'y': 20
      }
    )