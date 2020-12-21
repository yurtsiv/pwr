from tkinter import *

class StatusBar(Frame):
  STAUTS_TYPE_COLORS = {
    'info': '#91ff95',
    'warning': '#fcbd6a',
    'error': '#e37676'
  }

  def __init__(self, master, app_state):
    super().__init__(master)

    self.label = None

    self.app_state = app_state
    self.create_widgets()
    self.app_state.register_listener(self.on_state_change)

  def on_state_change(self):
    status = self.app_state.status

    if status is None:
      self.config(bg="white")
      self.label.config(text="", bg="white")
    else:
      bg = StatusBar.STAUTS_TYPE_COLORS[status['type']]
      self.config(bg=bg)
      self.label.config(text=status['text'], bg=bg)

  def create_widgets(self):
    self.label = Label(self)
    self.label.grid(row=0, sticky="wens")
