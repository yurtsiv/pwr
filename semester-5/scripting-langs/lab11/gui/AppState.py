from threading import Timer

class AppState:
    INITIAL_FILTERS = {
        'country_name': None,
        'continent': None,
        'month': None,
        'day': None,
        'sort_by': None,
        'rows_limit': None
    }

    def __init__(self):
        self.listeners = []

        self.state = {
            'cases_world': None,
            'country_names': None,
            'status': None,
            'saved_filters': [],
            'filters': {**AppState.INITIAL_FILTERS}
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
    
    @property
    def status(self):
        return self.state['status']

    def register_listener(self, cb):
        self.listeners.append(cb)
        cb()
    
    def unregister_listener(self, cb):
        self.listeners.remove(cb)
 
    def _notify_listeners(self):
        for cb in self.listeners:
            cb()

    def _check_empty_cases_world(self):
        if self.state['cases_world'] is None:
            self.state['status'] = {
                'type': 'warning',
                'text': 'Covid file is not loaded'
            }

    def merge_filters(self, filters):
        self.state['filters'] = {
            **self.state['filters'],
            **filters
        }
        self._check_empty_cases_world()
        self._notify_listeners()
    
    def set_filter(self, key, value):
        self.state['filters'][key] = value    
        self._check_empty_cases_world()
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

    def remove_all_saved_filters(self):
        self.state['saved_filters'] = []
        self._notify_listeners()

    def remove_saved_filter(self, idx):
        del self.state['saved_filters'][idx]
        self._notify_listeners()

    def clear_current_filters(self):
        self.state['filters'] = {**AppState.INITIAL_FILTERS}
        self._notify_listeners()
    
    def clear_status(self):
        def help():
            self.state['status'] = None
            self._notify_listeners()

        t = Timer(3.5, help)
        t.start()

    def set_status(self, type, text):
        self.state['status'] = {
            'type': type,
            'text': text
        }

        self._notify_listeners()
        self.clear_status()

    def set_warning_status(self, text):
        self.set_status('warning', text)

    def set_info_status(self, text):
        self.set_status('info', text)

    def set_error_status(self, text):
        self.set_status('error', text)