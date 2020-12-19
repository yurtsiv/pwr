class AppState:
    def __init__(self):
        self.change_listeners = []

        self.__state = {
            'cases_world': None,
            'country_names': None,
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
 
    @property
    def filters(self):
        return self.__state['filters']
    
    @property
    def cases_world(self):
        return self.__state['cases_world']

    @property
    def country_names(self):
        return self.__state['country_names']

    def on_change(self, cb):
        self.change_listeners.append(cb)
        cb(self.__state)
 
    def _notify_filters(self):
        for cb in self.change_listeners:
            cb(self.__state)

    def merge_filters(self, filters):
        self.__state['filters'] = {
            **self.__state['filters'],
            **filters
        }
        self._notify_filters()

    def set_filter(self, key, value):
        self.__state['filters'][key] = value
        self._notify_filters()

    def set_parsed_data(self, cases_world, country_names):
        self.__state['cases_world'] = cases_world
        self.__state['country_names'] = country_names
        self._notify_filters()
 