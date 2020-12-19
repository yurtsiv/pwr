from os import WEXITED
from tkinter import *

class Saved(Frame):
  def __init__(self, master, app_state, **kwargs):
      super().__init__(master, **kwargs)

      self.on_close = None
      self.app_state = app_state 

      self.create_widgets()

  def create_widgets(self):
    self.grid_columnconfigure(0, weight=1)
    self.grid_rowconfigure(0, weight=1)

    self.create_filters_list()
  
  def filters_to_str(self, filters):
    res = ''

    for key in ['country_name', 'continent', 'month', 'day']:
      if filters[key]:
        res += filters[key] + ' '
      
    if filters['sort_by']:
      res += ', sort by ' + filters['sort_by']

    if filters['rows_limit']:
      res += ', limit to ' + str(filters['rows_limit'])

    return res
  
  def on_list_box_double_click(self, event):
    selected_idx, = event.widget.curselection()

    self.app_state.merge_filters(
      self.app_state.saved_filters[selected_idx]
    )

    self.on_close()

  def create_filters_list(self):
    listbox = Listbox(self)
    saved_filters = self.app_state.saved_filters

    for i in range(0, len(saved_filters)):
      listbox.insert(i, self.filters_to_str(saved_filters[i]))
    
    listbox.bind('<Double-1>', self.on_list_box_double_click)

    listbox.grid(row=0, sticky="wens")
