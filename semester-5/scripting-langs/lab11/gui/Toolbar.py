import os
from tkinter import *
from PIL import Image, ImageTk

class Toolbar(Frame):
  BTN_SIZE = 30

  def __init__(self, master):
    super().__init__(master)

    # Keep images from being garbage collected
    self.__icon_imgs = []

    self.create_widgets()
  
  def on_open_file_click(self):
    print('open file')
    pass
  
  def create_widgets(self):
    self.create_button('open-file', self.on_open_file_click, 0)

  def create_button(self, icon_name, on_click, column):
    size = Toolbar.BTN_SIZE
    image = Image.open(os.getcwd() + '/gui/icons/' + icon_name + '.png')
    image = image.resize((size, size), Image.ANTIALIAS)
    image_tk = ImageTk.PhotoImage(image)
    self.__icon_imgs.append(image_tk)
    btn = Button(self, command=on_click, image = image_tk, width=size, height=size)
    btn.grid(row=0, column=column)

