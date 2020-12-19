from logic.Country_names import Country_names
import tkinter as tk

from logic.logic import transform_data
from gui.AppState import AppState
from gui.Filters import Filters
from gui.Toolbar import Toolbar
from gui.utils import format_result, date_range_from_filters

class Application(tk.Frame):
    def __init__(self, master):
        super().__init__(master)

        self.master = master
        self.text_cont = None
        self.app_state = AppState()

        self.pack()
        self.create_widgets()
        self.app_state.register_listener(self.refresh_table_content)

    def create_widgets(self):
        self.grid_rowconfigure(0, weight=0)
        self.grid_rowconfigure(1, weight=0)
        self.grid_rowconfigure(2, weight=1)
        self.grid_columnconfigure(0, weight=1)
        self.grid_columnconfigure(1, weight=0)

        # Toolbar
        toolbar = Toolbar(self, self.app_state)
        toolbar.grid(row=0, sticky="wens")

        # Filters
        filters = Filters(self, self.app_state)
        filters.grid(row=1, sticky="wens")

        # Output table
        scrollbar = tk.Scrollbar(self)
        self.text_cont = tk.Text(self, height=300)
        self.text_cont.config(state=tk.DISABLED)

        self.text_cont.grid(row=2, column=0, sticky="WENS")
        scrollbar.grid(row=2, column=1, sticky="NS")

        self.text_cont.config(yscrollcommand=scrollbar.set)
        scrollbar.config(command=self.text_cont.yview)

    def refresh_table_content(self):
        if self.app_state.cases_world is None:
            return

        filters = self.app_state.filters
        country_names = self.app_state.country_names

        result = transform_data(
            self.app_state.cases_world,
            country_names,
            date_range=date_range_from_filters(filters),
            continent=filters["continent"],
            country_code=country_names.get_code_by_name(
                filters["country_name"]),
            sort_by_key=filters["sort_by"],
            rows_limit=filters["rows_limit"]
        )

        result_str = format_result(result, country_names)

        self.text_cont.config(state=tk.NORMAL)
        self.text_cont.delete(1.0, tk.END)
        self.text_cont.insert(tk.END, result_str)
        self.text_cont.config(state=tk.DISABLED)


def run_gui():
    root = tk.Tk()
    root.title("Covid")

    # full screen
    root.wm_attributes('-zoomed', True)
    root.update()

    app = Application(root)
    app.mainloop()
