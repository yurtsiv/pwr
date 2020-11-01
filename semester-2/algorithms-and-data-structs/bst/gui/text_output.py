from tkinter import *

class TextOutput:
  def __init__(self, root):
    Label(root, text="Output:").grid(row=0, sticky="W")

    scrollbar = Scrollbar(root)
    self.text_cont = Text(root, height=10)
    self.text_cont.config(state=DISABLED)

    self.text_cont.grid(row=1, column=0, sticky="WENS")
    scrollbar.grid(row=1, column=1, sticky="NS")
  
    self.text_cont.config(yscrollcommand=scrollbar.set)
    scrollbar.config(command=self.text_cont.yview)
  
  def println(self, text):
    self.text_cont.config(state=NORMAL)
    self.text_cont.insert(END, text + '\n')
    self.text_cont.config(state=DISABLED)
  
  def clear(self):
    self.text_cont.config(state=NORMAL)
    self.text_cont.delete(1.0, END)
    self.text_cont.config(state=DISABLED)