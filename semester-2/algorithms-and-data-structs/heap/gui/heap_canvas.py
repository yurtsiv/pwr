from tkinter import *

class HeapCanvas:
  canvas = None

  def __init__(self, master, root):
    self.canvas = Canvas(root, bg="#fff")
    self.canvas.pack(fill=BOTH, expand=1)

  def draw(self, heap):
    self.canvas.delete('all')
    heap.draw(
      self.canvas,
      {
        'x': self.canvas.winfo_width() // 2,
        'y': 20
      }
    )