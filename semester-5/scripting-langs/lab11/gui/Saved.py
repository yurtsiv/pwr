import json
from tkinter import *
from tkinter import filedialog
from tkinter import messagebox

from gui.utils import parse_saved_filters


class Saved(Frame):
    FILE_TYPES = [
        ('JSON files', '*.json'),
    ]

    def __init__(self, master, app_state, **kwargs):
        super().__init__(master, **kwargs)

        self.on_close = None
        self.app_state = app_state

        self.listbox = None
        self.create_widgets()

        self.app_state.register_listener(self.on_state_change)

    def destroy(self):
        self.app_state.unregister_listener(self.on_state_change)
        return super().destroy()

    def on_state_change(self):
        saved_filters = self.app_state.saved_filters

        self.listbox.delete(0, END)
        for i in range(0, len(saved_filters)):
            self.listbox.insert(i, self.filters_to_str(saved_filters[i]))

    def create_widgets(self):
        self.grid_columnconfigure(0, weight=1)
        self.grid_rowconfigure(0, weight=1)

        self.create_filters_list()
        self.create_menu()

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
        self.listbox = listbox

        saved_filters = self.app_state.saved_filters

        for i in range(0, len(saved_filters)):
            listbox.insert(i, self.filters_to_str(saved_filters[i]))

        listbox.bind('<Double-1>', self.on_list_box_double_click)

        listbox.grid(row=0, sticky="wens")

    def on_file_open(self):
        file_name = filedialog.askopenfilename(
            filetypes=Saved.FILE_TYPES, parent=self)

        if not file_name or file_name == ():
            return

        try:
            filters = parse_saved_filters(file_name)
            self.app_state.set_saved_filters(filters)
        except Exception:
            messagebox.showerror("Error", "Couldn't parse the file")

    def on_save_as(self):
        file_name = filedialog.asksaveasfilename(parent=self)

        if not file_name or file_name == ():
            return

        if not file_name.endswith('json'):
            file_name += '.json'

        try:
            with open(file_name, 'w') as file:
                json.dump(self.app_state.saved_filters, file)
        except Exception as e:
            messagebox.showerror("Error", "Failed to save the file")
    
    def on_remove_item(self):
        sel = self.listbox.curselection()

        if sel == ():
            return
        
        selected_idx, = sel
        self.app_state.remove_saved_filter(selected_idx)
    
    def on_remove_all(self):
        self.app_state.remove_all_saved_filters()

    def create_menu(self):
        menu = Menu(self.master)

        self.master.config(menu=menu)

        fileMenu = Menu(menu, tearoff=0)
        menu.add_cascade(label="File", menu=fileMenu)
        fileMenu.add_command(label="Open", command=self.on_file_open)
        fileMenu.add_command(label="Save as", command=self.on_save_as)
        fileMenu.add_command(label="Exit", command=lambda: self.on_close())

        editMenu = Menu(menu, tearoff=0)
        menu.add_cascade(label="Edit", menu=editMenu)
        editMenu.add_command(label="Remove", command=self.on_remove_item)
        editMenu.add_command(label="Remove all", command=self.on_remove_all)

