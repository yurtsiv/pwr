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

        self.__country_sv = tk.StringVar()
        self.__continent_sv = tk.StringVar()
        self.__month_sv = tk.StringVar()
        self.__day_sv = tk.StringVar()
        self.__sort_by_sv = tk.StringVar()
        self.__rows_limit_sv = tk.StringVar()

        self.__day_combobox = None

        self.pack()
        self.create_widgets()

        self.__app_state.on_change(
            lambda state: self.on_app_state_filters_change(state['filters']))

    def create_widgets(self):
        self.create_autocomplete(
            "Country",
            "country_name",
            [Filters.EMPTY_CHOICE] + self.__country_names.country_names,
            self.__country_sv,
            0
        )

        self.create_autocomplete(
            "Continent",
            "continent",
            [Filters.EMPTY_CHOICE] + self.__country_names.continents,
            self.__continent_sv,
            1
        )

        self.create_combobox(
            "Month",
            "month",
            [Filters.EMPTY_CHOICE] + MONTHS,
            self.__month_sv,
            2,
        )

        self.__day_combobox = self.create_combobox(
            "Day",
            "day",
            [Filters.EMPTY_CHOICE],
            self.__day_sv,
            3,
        )

        self.create_combobox(
            "Sort by",
            "sort_by",
            [Filters.EMPTY_CHOICE] + SORT_BY_KEYS,
            self.__sort_by_sv,
            4
        )

        self.create_int_input(
            "Rows limit",
            "rows_limit",
            self.__rows_limit_sv,
            5
        )

    def on_app_state_filters_change(self, filters):
        self.__country_sv.set(filters['country_name'] or Filters.EMPTY_CHOICE)
        self.__continent_sv.set(filters['continent'] or Filters.EMPTY_CHOICE)
        self.__month_sv.set(filters['month'] or Filters.EMPTY_CHOICE)
        self.__day_sv.set(filters['day'] or Filters.EMPTY_CHOICE)
        self.__sort_by_sv.set(filters['sort_by'] or Filters.EMPTY_CHOICE)
        self.__rows_limit_sv.set(str(filters['rows_limit'] or ''))

    def create_autocomplete(self, label, filter_key, values, sv, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        sv.trace("w", lambda name, index, mode, sv=sv: self.on_combobox_change(filter_key, sv))
        box = autocomplete.AutocompleteCombobox(self, completevalues=values, textvariable=sv)
        box.grid(row=1, column=column)

        return box
    
    def create_combobox(self, label, filter_key, values, sv, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        sv.trace("w", lambda name, index, mode, sv=sv: self.on_combobox_change(filter_key, sv))
        box = tk.ttk.Combobox(self, values=values, textvariable=sv)
        box.grid(row=1, column=column)

        return box
    
    def on_month_change(self, month):
        if month is None:
            return self.__app_state.merge_filters({
                'month': None,
                'day': None
            })

        month_num = MONTHS.index(month) + 1
        (_, days_in_month) = monthrange(YEAR, month_num)

        days = [str(e) for e in list(range(1, days_in_month + 1))]
        self.__day_combobox.configure(
            values=[Filters.EMPTY_CHOICE] + days
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

    def on_combobox_change(self, filter_key, sv):
        raw_value = sv.get()
        value = None if raw_value == Filters.EMPTY_CHOICE else raw_value

        if self.__app_state.filters[filter_key] == value:
            return;

        if filter_key == 'month':
            self.on_month_change(value)
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


    def create_int_input(self, label, filter_key, sv, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        entry = tk.Entry(self, textvariable=sv)
        sv.trace("w", lambda name, index, mode, sv=sv: self.on_int_input_change(filter_key, sv))
        entry.grid(row=1, column=column)

        return sv

    def on_int_input_change(self, filter_key, sv):
        value = sv.get()

        if self.__app_state.filters[filter_key] == value:
            return;

        if not value:
            self.__app_state.set_filter(filter_key, None)
            return

        try:
            value = int(value) 
        except:
            return

        self.__app_state.set_filter(filter_key, value)
