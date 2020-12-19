class AppState:
    def __init__(self):
        self.listeners = []

        self.state = {
            'cases_world': None,
            'country_names': None,
            'saved_filters': [],
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
    def filters(self):
        return self.state['filters']
    
    @property
    def cases_world(self):
        return self.state['cases_world']

    @property
    def country_names(self):
        return self.state['country_names']

    @property
    def saved_filters(self):
        return self.state['saved_filters']

    def on_change(self, cb):
        self.listeners.append(cb)
        cb(self.state)
 
    def _notify_filters(self):
        for cb in self.listeners:
            cb(self.state)

    def merge_filters(self, filters):
        self.state['filters'] = {
            **self.state['filters'],
            **filters
        }
        self._notify_filters()

    def set_filter(self, key, value):
        self.state['filters'][key] = value
        self._notify_filters()

    def set_parsed_data(self, cases_world, country_names):
        self.state['cases_world'] = cases_world
        self.state['country_names'] = country_names
        self._notify_filters()

    def save_current_filters(self):
        self.state['saved_filters'].append({ **self.state['filters'] })
 