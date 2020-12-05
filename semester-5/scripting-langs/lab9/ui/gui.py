import sys
import tkinter as tk
from tkinter import ttk
from tkcalendar import DateEntry
from datetime import datetime

from logic.logic import parse_data, transform_data
from ui.utils import format_result

class Filters(tk.Frame):
    EMPTY_CHOICE = '(none)'

    def __init__(self, master=None):
        super().__init__(master)

        self.on_filter = None
        self.__filters = {
            "country_name": None,
            "continent": None,
            "date_from": None,
            "date_to": None,
            "sort_by_key": None,
            "rows_limit": None
        }

        self.pack()
        self.create_widgets()
    
    @property
    def filters(self):
      return self.__filters

    def create_widgets(self):
        self.grid_rowconfigure(0)
        self.grid_rowconfigure(1)

        self.grid_columnconfigure(0)
        self.grid_columnconfigure(1)
        self.grid_columnconfigure(2)
        self.grid_columnconfigure(3)
        self.grid_columnconfigure(4)
        self.grid_columnconfigure(5)
        self.grid_columnconfigure(6)

        self.create_combobox(
            "Country",
            "country_name",
            ["(none)", "Ukraine", "Poland"],
            0
        )

        self.create_combobox(
            "Continent",
            "continent",
            ["(none)", "Asia"],
            1
        )

        self.create_datepicker(
            "Date from",
            "date_from",
            2
        )

        self.create_datepicker(
            "Date to",
            "date_to",
            3
        )

        self.create_combobox(
            "Sort by",
            "sort_by_key",
            ["(none)", "cases", "deaths"],
            4
        )

        self.create_int_input(
            "Rows limit",
            "rows_limit",
            5
        )

        tk.Button(self, text="Filter", command=lambda: self.on_filter(self.__filters)).grid(row=1, column=6)
 
    def create_combobox(self, label, filter_key, value, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")
        box = ttk.Combobox(self, value=value)
        box.bind('<<ComboboxSelected>>', self.on_combobox_change(filter_key))
        box.grid(row=1, column=column)

    def on_combobox_change(self, filter_key):
        def handle(event):
            value = event.widget.get()

            if value == Filters.EMPTY_CHOICE:
                self.__filters[filter_key] = None
            else:
                self.__filters[filter_key] = value

        return handle

    def create_datepicker(self, label, filter_key, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        container = tk.Frame(self)
        container.grid_columnconfigure(0)
        container.grid_columnconfigure(1)

        date_picker = DateEntry(container)
        date_picker.config(validate='none')
        date_picker.bind('<<DateEntrySelected>>',
                         self.on_date_pick(filter_key))
        date_picker.delete(0, tk.END)
        date_picker.grid(row=0, column=0)

        clear_btn = tk.Button(
            container,
            text="x",
            command=self.on_clear_date_click(date_picker, filter_key)
        )
        clear_btn.grid(row=0, column=1)

        container.grid(row=1, column=column)

    def on_clear_date_click(self, date_entry, filter_key):
        def handle():
            date_entry.delete(0, tk.END)
            self.__filters[filter_key] = None

        return handle

    def on_date_pick(self, filter_key):
        def handle(event):
            value = event.widget.get()

            date = datetime.strptime(value, "%m/%d/%y")
            self.__filters[filter_key] = date

        return handle

    def create_int_input(self, label, filter_key, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")
        int_input = tk.Entry(self)
        int_input.bind('<KeyRelease>', self.on_int_input_change(filter_key))
        int_input.grid(row=1, column=column)

    def on_int_input_change(self, filter_key):
        def handle(event):
          value = event.widget.get()

          if not value:
            self.__filters[filter_key] = None
            return

          try:
            self.__filters[filter_key] = int(value)
          except:
            pass

        return handle


class Application(tk.Frame):
    def __init__(self, master, cases_world, country_names):
        super().__init__(master)

        self.master = master
        self.cases_world = cases_world
        self.country_names = country_names
        self.text_cont = None

        self.pack()
        self.create_widgets()
    
    def on_filter(self, filters):
      self.fill_table(filters)

    def create_widgets(self):
        self.grid_rowconfigure(0, weight=0)
        self.grid_rowconfigure(1, weight=1)

        # Filters
        filters = Filters(self)
        filters.on_filter = self.on_filter
        filters.grid(row=0, sticky="wens")

        # Output table
        scrollbar = tk.Scrollbar(self)
        self.text_cont = tk.Text(self, height=200)
        self.text_cont.config(state=tk.DISABLED)

        self.text_cont.grid(row=1, column=0, sticky="WENS")
        scrollbar.grid(row=1, column=1, sticky="NS")
      
        self.text_cont.config(yscrollcommand=scrollbar.set)
        scrollbar.config(command=self.text_cont.yview)

        self.fill_table(filters.filters)
    
    def fill_table(self, filters):
      result = transform_data(
        self.cases_world,
        self.country_names,
        date_range=(filters["date_from"], filters["date_to"]),
        continent=filters["continent"],
        country_code=self.country_names.get_code_by_name(filters["country_name"]),
        sort_by_key=filters["sort_by_key"],
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
    app = Application(root, cases_world, country_names)
    app.mainloop()
