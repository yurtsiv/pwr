import sys
import tkinter as tk
from tkinter import ttk
from datetime import datetime

from logic.AppState import AppState
from logic.logic import parse_data, transform_data
from gui.utils import format_result
from gui.Filters import Filters

class Application(tk.Frame):
    def __init__(self, master, cases_world, country_names):
        super().__init__(master)

        self.master = master
        self.cases_world = cases_world
        self.country_names = country_names
        self.text_cont = None
        self.app_state = AppState()

        self.pack()
        self.create_widgets()

    def on_filter(self, filters):
        self.set_table_content(filters)

    def create_widgets(self):
        self.grid_rowconfigure(0, weight=0)
        self.grid_rowconfigure(1, weight=2)
        self.grid_columnconfigure(0, weight=1)
        self.grid_columnconfigure(1, weight=0)

        # Filters
        filters = Filters(self, self.country_names, self.app_state)
        filters.grid(row=0, sticky="wens")

        # Output table
        scrollbar = tk.Scrollbar(self)
        self.text_cont = tk.Text(self, height=300)
        self.text_cont.config(state=tk.DISABLED)

        self.text_cont.grid(row=1, column=0, sticky="WENS")
        scrollbar.grid(row=1, column=1, sticky="NS")

        self.text_cont.config(yscrollcommand=scrollbar.set)
        scrollbar.config(command=self.text_cont.yview)

        self.app_state.on_change(
            lambda state:
                self.set_table_content(state['filters'])
        )

    def set_table_content(self, filters):
        result = transform_data(
            self.cases_world,
            self.country_names,
            # date_range=(filters["date_from"], filters["date_to"]),
            continent=filters["continent"],
            country_code=self.country_names.get_code_by_name(
                filters["country_name"]),
            sort_by_key=filters["sort_by"],
            rows_limit=filters["rows_limit"]
        )

        result_str = format_result(result, self.country_names)

        self.text_cont.config(state=tk.NORMAL)
        self.text_cont.delete(1.0, tk.END)
        self.text_cont.insert(tk.END, result_str)
        self.text_cont.config(state=tk.DISABLED)


print("Parsing the file. Please wait...")
cases_world, country_names = parse_data()

def run_gui():
    root = tk.Tk()
    root.title("Covid")

    # full screen
    root.wm_attributes('-zoomed', True)
    root.update()

    app = Application(root, cases_world, country_names)
    app.mainloop()
