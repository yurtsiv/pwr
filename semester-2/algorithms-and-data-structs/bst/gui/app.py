from tkinter import *
from gui.toolbar import Toolbar
from gui.bst_canvas import BSTCanvas
from gui.text_output import TextOutput
from bst import BST

class App:
  bst = BST()

  def __init__(self, master):
    # open full screen
    master.wm_attributes('-zoomed', True)
    master.update()

    self.init_ui_elems(master)

  def init_ui_elems(self, master):
    master.grid_rowconfigure(0, weight=1)
    master.grid_columnconfigure(0, weight=1)

    # Canvas
    canvas_cont = Frame(master)
    self.bst_canvas = BSTCanvas(master, canvas_cont)
    canvas_cont.grid(row=0, sticky="WENS")

    # Toolbar & text ouput
    bottom_section = Frame(master, bd=5, relief=RIDGE)
    bottom_section.grid_columnconfigure(1, weight=3)
    bottom_section.grid_rowconfigure(0, weight=1)
    bottom_section.grid(row=1, sticky="WENS")

    # Toolbar
    toolbar_cont = Frame(bottom_section)
    self.toolbar = Toolbar(
      master,
      toolbar_cont,
      on_add_new_node=self.on_add_new_node,
      on_remove_node=self.on_remove_node,
      on_show_subtree=self.on_show_subtree,
      on_get_id=self.on_get_id,
      on_size_click=self.on_size_click,
      on_root_click=self.on_root_click,
      on_min_click=self.on_min_click,
      on_max_click=self.on_max_click,
      on_print_click=self.on_print_click,
      on_reset_click=self.on_reset_click
    )

    toolbar_cont.grid(row=0, column=0, sticky="WENS")

    # Text output
    text_output_cont = Frame(bottom_section)
    text_output_cont.grid_columnconfigure(0, weight=1)
    text_output_cont.grid_rowconfigure(1, weight=1)
    text_output_cont.grid(row=0, column=1, sticky="WENS")
    self.text_output = TextOutput(text_output_cont)

  def on_size_click(self):
    self.text_output.println(
      "Tree size: " + str(self.bst.size)
    )
  
  def on_root_click(self):
    self.text_output.println(
      "Root element: " + str(self.bst.root_key())
    )

  def on_min_click(self):
    self.text_output.println(
      "Min element: " + str(self.bst.min())
    )

  def on_max_click(self):
    self.text_output.println(
      "Max element: " + str(self.bst.max())
    )
  
  def on_print_click(self):
    str_repres= self.bst.to_string()
    self.text_output.println(
      'In-order: ' + str_repres['in_order'] + '\n' +
      'Pre-order: ' + str_repres['pre_order'] + '\n' +
      'Post-order: ' + str_repres['post_order']
    )

  def on_reset_click(self):
    self.bst = BST()
    self.bst_canvas.draw(self.bst)
    self.text_output.clear()

  def on_show_subtree(self, root_key):
    new_bst = self.bst.subtree(root_key)
    if new_bst:
      self.bst = new_bst
      self.bst_canvas.draw(self.bst)
    else:
      self.text_output.println('WARNING: There is no ' + str(root_key) + ' in the tree')

  def on_add_new_node(self, key):
    inserted = self.bst.add(key)
    if inserted:
      self.bst_canvas.draw(self.bst)
    else:
      self.text_output.println('WARNING: Node ' + str(key) + ' was not added since it already exists')

  def on_remove_node(self, key):
    removed = self.bst.remove(key)
    if removed:
      self.bst_canvas.draw(self.bst)
    else:
      self.text_output.println('WARNING: There is no ' + str(key) + ' in the tree')

  def on_get_id(self, key):
    id = self.bst.find(key)
    if id:
      self.text_output.println('ID of ' + str(key) + ': ' + str(id))
    else:
      self.text_output.println('WARNING: There is no ' + str(key) + ' in the tree')