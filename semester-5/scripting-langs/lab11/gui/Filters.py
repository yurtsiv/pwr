import os
from ttkwidgets import autocomplete
import tkinter as tk
from tkinter import *
from calendar import monthrange
from PIL import Image, ImageTk

from logic.const import SORT_BY_KEYS
from gui.const import MONTHS, YEAR


class Filters(tk.Frame):
    EMPTY_CHOICE = '(empty)'
    BTN_SIZE = 20

    def __init__(self, master, app_state):
        super().__init__(master)

        self.app_state = app_state

        self.country_sv = tk.StringVar()
        self.continent_sv = tk.StringVar()
        self.month_sv = tk.StringVar()
        self.day_sv = tk.StringVar()
        self.sort_by_sv = tk.StringVar()
        self.rows_limit_sv = tk.StringVar()

        self.country_combobox = None
        self.continent_combobox = None
        self.day_combobox = None
        self.save_filters_btn = None
        self.clear_filters_btn = None

        # Keep images from being garbage collected
        self._icon_imgs = []

        self.create_widgets()
        self.app_state.register_listener(self.on_app_state_change)

    def create_widgets(self):
        country_names = []
        continents = []

        country_names_obj = self.app_state.country_names
        if country_names_obj is not None:
            country_names = country_names_obj.country_names
            continents = country_names_obj.continents

        self.country_combobox = self.create_autocomplete(
            "Country",
            "country_name",
            [Filters.EMPTY_CHOICE] + country_names,
            self.country_sv,
            0
        )

        self.continent_combobox = self.create_autocomplete(
            "Continent",
            "continent",
            [Filters.EMPTY_CHOICE] + continents,
            self.continent_sv,
            1
        )

        self.create_combobox(
            "Month",
            "month",
            [Filters.EMPTY_CHOICE] + MONTHS,
            self.month_sv,
            2,
        )

        self.day_combobox = self.create_combobox(
            "Day",
            "day",
            [Filters.EMPTY_CHOICE],
            self.day_sv,
            3,
        )

        self.create_combobox(
            "Sort by",
            "sort_by",
            [Filters.EMPTY_CHOICE] + SORT_BY_KEYS,
            self.sort_by_sv,
            4
        )

        self.create_int_input(
            "Rows limit",
            "rows_limit",
            self.rows_limit_sv,
            5
        )

        self.clear_filters_btn = self.create_icon_btn(
            "clear",
            self.on_clear_filters_click,
            6
        )

        self.clear_filters_btn.config(state='disabled')

        self.save_filters_btn = self.create_icon_btn(
            "saved",
            self.on_save_filters_click,
            7
        )

        self.save_filters_btn.config(state='disabled')

    def on_save_filters_click(self):
        self.app_state.save_current_filters()
        self.app_state.set_info_status('Filters saved')
    
    def on_clear_filters_click(self):
        self.app_state.clear_current_filters()

    def create_icon_btn(self, icon_name, on_click, column):
        size = Filters.BTN_SIZE
        image = Image.open(os.getcwd() + '/gui/icons/' + icon_name + '.png')
        image = image.resize((size, size), Image.ANTIALIAS)
        image_tk = ImageTk.PhotoImage(image)
        self._icon_imgs.append(image_tk)
        btn = Button(self, command=on_click, image=image_tk,
                     width=size, height=size)
        btn.grid(row=1, column=column)

        return btn

    def on_app_state_change(self):
        filters = self.app_state.state['filters']
        country_names_obj = self.app_state.state['country_names']

        if country_names_obj is not None:
            country_names = country_names_obj.country_names
            continents = country_names_obj.continents

            self.country_combobox.configure(
                values=[Filters.EMPTY_CHOICE] + country_names
            )

            self.continent_combobox.configure(
                values=[Filters.EMPTY_CHOICE] + continents
            )

        self.country_sv.set(filters['country_name'] or Filters.EMPTY_CHOICE)
        self.continent_sv.set(filters['continent'] or Filters.EMPTY_CHOICE)
        self.month_sv.set(filters['month'] or Filters.EMPTY_CHOICE)
        self.day_sv.set(filters['day'] or Filters.EMPTY_CHOICE)
        self.sort_by_sv.set(filters['sort_by'] or Filters.EMPTY_CHOICE)
        self.rows_limit_sv.set(str(filters['rows_limit'] or ''))

        btns_state = 'active' if any(filters.values()) else 'disabled'
        self.save_filters_btn.config(state=btns_state)
        self.clear_filters_btn.config(state=btns_state)

    def create_autocomplete(self, label, filter_key, values, sv, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        sv.trace("w", lambda name, index, mode,
                 sv=sv: self.on_combobox_change(filter_key, sv))
        box = autocomplete.AutocompleteCombobox(
            self, completevalues=values, textvariable=sv)
        box.grid(row=1, column=column)

        return box

    def create_combobox(self, label, filter_key, values, sv, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        sv.trace("w", lambda name, index, mode,
                 sv=sv: self.on_combobox_change(filter_key, sv))
        box = tk.ttk.Combobox(self, values=values, textvariable=sv)
        box.grid(row=1, column=column)

        return box

    def on_month_change(self, month):
        if month is None:
            return self.app_state.merge_filters({
                'month': None,
                'day': None
            })

        month_num = MONTHS.index(month) + 1
        (_, days_in_month) = monthrange(YEAR, month_num)

        days = [str(e) for e in list(range(1, days_in_month + 1))]
        self.day_combobox.configure(
            values=[Filters.EMPTY_CHOICE] + days
        )

        day = self.app_state.state['filters']['day']

        if not day:
            self.app_state.set_filter('month', month)
        else:
            day = day if int(day) <= days_in_month else None
            self.app_state.merge_filters({
                'month': month,
                'day': day
            })

    def on_combobox_change(self, filter_key, sv):
        raw_value = sv.get()
        value = None if raw_value == Filters.EMPTY_CHOICE else raw_value

        if self.app_state.filters[filter_key] == value:
            return

        if filter_key == 'month':
            self.on_month_change(value)
        elif filter_key == 'country_name':
            self.app_state.merge_filters({
                'country_name': value,
                'continent': None
            })
        elif filter_key == 'continent':
            self.app_state.merge_filters({
                'continent': value,
                'country_name': None
            })
        else:
            self.app_state.set_filter(filter_key, value)

    def create_int_input(self, label, filter_key, sv, column):
        tk.Label(self, text=label).grid(row=0, column=column, sticky="W")

        entry = tk.Entry(self, textvariable=sv)
        sv.trace("w", lambda name, index, mode,
                 sv=sv: self.on_int_input_change(filter_key, sv))
        entry.grid(row=1, column=column)

        return sv

    def on_int_input_change(self, filter_key, sv):
        value = sv.get()

        if self.app_state.filters[filter_key] == value:
            return

        if not value:
            self.app_state.set_filter(filter_key, None)
            return

        try:
            value = int(value)
        except:
            return

        self.app_state.set_filter(filter_key, value)
