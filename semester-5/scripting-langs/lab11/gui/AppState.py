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

    def register_listener(self, cb):
        self.listeners.append(cb)
        cb()
    
    def unregister_listener(self, cb):
        self.listeners.remove(cb)
 
    def _notify_listeners(self):
        for cb in self.listeners:
            cb()

    def merge_filters(self, filters):
        self.state['filters'] = {
            **self.state['filters'],
            **filters
        }
        self._notify_listeners()

    def set_filter(self, key, value):
        self.state['filters'][key] = value
        self._notify_listeners()

    def set_parsed_data(self, cases_world, country_names):
        self.state['cases_world'] = cases_world
        self.state['country_names'] = country_names
        self._notify_listeners()

    def save_current_filters(self):
        self.state['saved_filters'].append({ **self.state['filters'] })
    
    def set_saved_filters(self, filters):
        self.state['saved_filters'] = filters
        self._notify_listeners()
 
    def remove_saved_filters(self, idx):
        del self.state['saved_filters'][idx]
        self._notify_listeners()
 