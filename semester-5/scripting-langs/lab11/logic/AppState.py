class AppState:
    def __init__(self):
        self.__listeners = []

        self.__state = {
            'filters': {
                'country_name': None,
                'continent': None,
                'month': None,
                'day': None,
                'sort_by': None,
                'rows_limit': None
            }
        }

    @property
    def state(self):
        return self.__state

    def on_change(self, cb):
        self.__listeners.append(cb)
        cb(self.__state)

    def _notify_listeners(self):
        for cb in self.__listeners:
            cb(self.__state)

    def merge_filters(self, filters):
        self.__state['filters'] = {
            **self.__state['filters'],
            **filters
        }
        self._notify_listeners()

    def set_filter(self, key, value):
        self.__state['filters'][key] = value
        self._notify_listeners()