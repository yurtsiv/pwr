import os
from tkinter import *
from tkinter import filedialog
from tkinter import messagebox
from PIL import Image, ImageTk

from logic.logic import parse_data, transform_data
from gui.Saved import Saved

class Toolbar(Frame):
    FILE_TYPES = [
        ('Text files', '*.txt'),
        ('CSV files', '*.csv')
    ]
    BTN_SIZE = 30

    def __init__(self, master, app_state):
        super().__init__(master)

        self.app_state = app_state

        # Keep images from being garbage collected
        self._icon_imgs = []

        self.create_widgets()

    def create_widgets(self):
        self.create_button('open-file', self.on_open_file_click, 0)
        self.create_button('saved', self.on_saved_click, 1)

    def create_button(self, icon_name, on_click, column):
        size = Toolbar.BTN_SIZE
        image = Image.open(os.getcwd() + '/gui/icons/' + icon_name + '.png')
        image = image.resize((size, size), Image.ANTIALIAS)
        image_tk = ImageTk.PhotoImage(image)
        self._icon_imgs.append(image_tk)
        btn = Button(self, command=on_click, image=image_tk,
                     width=size, height=size)
        btn.grid(row=0, column=column)

    def on_open_file_click(self):
        file_name = filedialog.askopenfilename(
            filetypes=Toolbar.FILE_TYPES)

        if not file_name or file_name == ():
            return
 
        try:
            cases_world, country_names = parse_data(file_name)
            self.app_state.set_parsed_data(cases_world, country_names)
        except Exception as e:
            messagebox.showerror("Error", "Couldn't parse the file")

    def on_saved_click(self):
        tl = Toplevel(self)
        tl.wm_title("Saved filters")
        tl.wm_geometry("500x500")

        saved = Saved(tl, self.app_state, background="black")
        saved.on_close = lambda: tl.destroy()
        saved.pack(expand=1, fill=BOTH)
