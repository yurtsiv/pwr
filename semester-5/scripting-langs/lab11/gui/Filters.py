from ttkwidgets import autocomplete
import tkinter as tk
from calendar import monthrange

from logic.const import SORT_BY_KEYS
from gui.const import MONTHS, YEAR

class Filters(tk.Frame):
    EMPTY_CHOICE = 'Not selected...'

    def __init__(self, master, country_names, app_state):
        super().__init__(master)

        self.__app_state = app_state
        self.__country_names = country_names

        self.__country_combobox = None
        self.__continent_combobox = None
        self.__month_combobox = None
        self.__day_combobox = None
        self.__sort_by_combobox = None
        self.__rows_limit_sv = None

        self.pack()
        self.create_widgets()

        self.__app_state.on_change(
            lambda state: self.on_app_state_filters_change(state['filters']))

    def create_widgets(self):
        self.__country_combobox = self.create_combobox(
            "Country",
            "country_name",
            [Filters.EMPTY_CHOICE] + self.__country_names.country_names,
            0
        )

        self.__continent_combobox = self.create_combobox(
            "Continent",
            "continent",
            [Filters.EMPTY_CHOICE] + self.__country_names.continents,
            1
        )

        self.__month_combobox = self.create_combobox(
            "Month",
            "month",
            [Filters.EMPTY_CHOICE] + MONTHS,
            2,
        )

        self.__day_combobox = self.create_combobox(
            "Day",
            "day",
            [Filters.EMPTY_CHOICE],
            3,
        )

        self.__sort_by_combobox = self.create_combobox(
            "Sort by",
            "sort_by",
            [Filters.EMPTY_CHOICE] + SORT_BY_KEYS,
            4
        )

        self.__rows_limit_sv = self.create_int_input(
            "Rows limit",
            "rows_limit",
            5
        )

    def on_app_state_filters_change(self, filters):
        self.__country_combobox.set(filters['country_name'] or Filters.EMPTY_CHOICE)
        self.__continent_combobox.set(filters['continent'] or Filters.EMPTY_CHOICE)
        self.__month_combobox.set(filters['month'] or Filters.EMPTY_CHOICE)
        self.__day_combobox.set(filters['day'] or Filters.EMPTY_CHOICE)
        self.__sort_by_combobox.set(filters['sort_by'] or Filters.EMPTY_CHOICE)
        self.__rows_limit_sv.set(str(filters['rows_limit'] or ''))

    def create_combobox(self, label, filter_key, value, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        box = autocomplete.AutocompleteCombobox(self, completevalues=value)
        box.bind('<<ComboboxSelected>>', self.on_combobox_change(filter_key))
        box.grid(row=1, column=column)

        return box
    
    def on_month_change(self, month):
        if month == Filters.EMPTY_CHOICE:
            return self.__app_state.merge_filters({
                'month': None,
                'day': None
            })

        month_num = MONTHS.index(month) + 1
        (_, days_in_month) = monthrange(YEAR, month_num)

        days = [str(e) for e in list(range(1, days_in_month + 1))]
        self.__day_combobox.set_completion_list(
            [Filters.EMPTY_CHOICE] + days
        )

        day = self.__app_state.state['filters']['day']

        if not day:
            self.__app_state.set_filter('month', month)
        else:
            day = day if int(day) <= days_in_month else None
            self.__app_state.merge_filters({
                'month': month,
                'day': day
            })

    def on_combobox_change(self, filter_key):
        def handle(event):
            value = event.widget.get()

            if filter_key == 'month':
                self.on_month_change(value)
            elif value == Filters.EMPTY_CHOICE:
                self.__app_state.set_filter(filter_key, None)
            elif filter_key == 'country_name':
                self.__app_state.merge_filters({
                  'country_name': value,
                  'continent': None
                })
            elif filter_key == 'continent':
                self.__app_state.merge_filters({
                  'continent': value,
                  'country_name': None
                })
            else:
                self.__app_state.set_filter(filter_key, value)

        return handle

    def create_int_input(self, label, filter_key, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        sv = tk.StringVar()
        sv.trace("w", lambda name, index, mode, sv=sv: self.on_int_input_change(filter_key)(sv))

        entry = tk.Entry(self, textvariable=sv)
        entry.grid(row=1, column=column)

        return sv

    def on_int_input_change(self, filter_key):
        def handle(sv):
            value = sv.get()

            if not value:
                self.__app_state.set_filter(filter_key, None)
                return

            try:
              value = int(value) 
            except:
              return

            self.__app_state.set_filter(filter_key, value)

        return handle
