from tkinter import *
from gui.toolbar import Toolbar
from gui.heap_canvas import HeapCanvas
from gui.text_output import TextOutput
from heap import Heap

class App:
  heap = Heap()

  def __init__(self, master):
    self._display_warning = True
  
    # open full screen
    master.wm_attributes('-zoomed', True)
    master.update()

    self.init_ui_elems(master)

  def init_ui_elems(self, master):
    master.grid_rowconfigure(0, weight=1)
    master.grid_rowconfigure(1, weight=0)
    master.grid_columnconfigure(0, weight=1)

    # Canvas
    canvas_cont = Frame(master)
    self.heap_canvas = HeapCanvas(master, canvas_cont)
    canvas_cont.grid(row=0, sticky="WENS")

    # Toolbar & text ouput container
    bottom_section = Frame(master, bd=5, relief=RIDGE)
    bottom_section.grid(row=1, sticky="WENS")
    bottom_section.grid_columnconfigure(0, weight=0)
    bottom_section.grid_columnconfigure(1, weight=3)
    bottom_section.grid_rowconfigure(0, weight=1)

    # Toolbar
    toolbar_cont = Frame(bottom_section)
    self.toolbar = Toolbar(
      master,
      toolbar_cont,
      on_add_new_node=self.on_add_new_node,
      on_size_click=self.on_size_click,
      on_min_click=self.on_min_click,
      on_max_click=self.on_max_click,
      on_print_click=self.on_print_click,
      on_reset_click=self.on_reset_click,
      on_max_heap_toggle=self.on_max_heap_toggle,
      on_levels_click=self.on_levels_click
    )

    toolbar_cont.grid(row=0, column=0, sticky="WENS")

    # Text output
    text_output_cont = Frame(bottom_section)
    text_output_cont.grid_columnconfigure(0, weight=1)
    text_output_cont.grid_rowconfigure(1, weight=1)
    text_output_cont.grid(row=0, column=1, sticky="WENS")
    self.text_output = TextOutput(text_output_cont)
  
  def on_levels_click(self):
    self.text_output.println(
      "Complete levels: " + str(self.heap.complete_levels)
    )

  def on_max_heap_toggle(self):
    self.heap.toggle_max_heap()
    self.heap_canvas.draw(self.heap)

  def on_size_click(self):
    self.text_output.println(
      "Tree size: " + str(self.heap.size)
    )

  def on_min_click(self):
    self.text_output.println(
      "Min element: " + str(self.heap.min)
    )

  def on_max_click(self):
    self.text_output.println(
      "Max element: " + str(self.heap.max)
    )

  def on_print_click(self):
    str_repres= self.heap.string_representations()
    self.text_output.println(
      'In-order: ' + str_repres['in_order'] + '\n' +
      'Pre-order: ' + str_repres['pre_order'] + '\n' +
      'Post-order: ' + str_repres['post_order']
    )

  def on_reset_click(self):
    self.heap = Heap()
    self.heap_canvas.draw(self.heap)
    self.text_output.clear()
    self._display_warning = True

  def on_add_new_node(self, keys):
    for key in keys:
      if key >= 100:
        self.text_output.println("WARNING: Node " + str(key) + " was not added (should be < 100)")
      else:
        self.heap.add(key)
    
    if self._display_warning and self.heap.complete_levels >= 6:
      self.text_output.println("WARNING: Nodes may start (or started) overlapping and disappearing from your screen")
      self._display_warning = False

    self.heap_canvas.draw(self.heap)
