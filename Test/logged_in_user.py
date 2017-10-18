"""Class representing the logged in user"""

class LoggedInUser:
    """Class representing the logged in user"""

    def __init__(self, details=dict()):
        """initializes a user with details (if provided)"""
        self.__the_user = details

    def __getitem__(self, item):
        return self.__the_user[item]

    def keys(self):
        """this is necessary when i try to overload the UserDict.Mixin"""
        return self.__the_user.values()

    def __iter__(self):
        for k in self.keys():
            yield k

    def set_username(self, username):
        """sets the username"""
        self.__the_user['username'] = username

    def get_username(self):
        """retrieves the username"""
        if 'username' in self.__the_user.keys():
            return self.__the_user['username']
        return False

    def set_name(self, name):
        """sets the name of the user"""
        self.__the_user['name'] = name

    def get_name(self):
        if 'name' in self.__the_user.keys():
            return self.__the_user['name']
        return False

    def set_userid(self, userid):
        self.__the_user['id'] = userid

    def get_userid(self):
        if 'id' in self.__the_user.keys():
            return self.__the_user['id']
        return False

    def set_user_calendars(self, calendar_id, calendar_name, calendar_rights):
        if 'calendars' not in self.__the_user.keys():
            self.__the_user['calendars'] = dict()
        self.__the_user['calendars'][calendar_id] = dict()
        self.__the_user['calendars'][calendar_id]['calendar_rights'] = calendar_rights
        self.__the_user['calendars'][calendar_id]['calendar_name'] = calendar_name

    def get_user_calendars(self):
        if 'calendars' in self.__the_user.keys():
            return self.__the_user['calendars']
        return False

    def set_user_events(self, calendar_id, event_id, name, start, end, interval, terminatedate):
        if 'events_list' not in self.__the_user['calendars'][calendar_id].keys():
            self.__the_user['calendars'][calendar_id]['events_list'] = []
        self.__the_user['calendars'][calendar_id]['events_list'].append(event_id)
        
        if 'events' not in self.__the_user['calendars'][calendar_id].keys():
            self.__the_user['calendars'][calendar_id]['events'] = dict()
        self.__the_user['calendars'][calendar_id]['events'][event_id] = dict()
        self.__the_user['calendars'][calendar_id]['events'][event_id]['name'] = name
        self.__the_user['calendars'][calendar_id]['events'][event_id]['start'] = start
        self.__the_user['calendars'][calendar_id]['events'][event_id]['end'] = end
        self.__the_user['calendars'][calendar_id]['events'][event_id]['interval'] = interval
        self.__the_user['calendars'][calendar_id]['events'][event_id]['terminatedate'] = terminatedate

    def get_user_events(self):
        if 'calendars' in self.__the_user.keys():
            user_events = []
            for calendar_id in self.__the_user['calendars'].keys():
                if 'events_list' in self.__the_user['calendars'][calendar_id].keys():
                    user_events.extend(self.__the_user['calendars'][calendar_id]['events_list'])
            return user_events
        return False

    def get_user_event(self, calendar_id, event_id):
        pass

    def clear(self):
        """clears the class"""
        self.__the_user = LoggedInUser(dict())

    def contents(self):
        """return the details of the logged in user"""
        return self.__the_user
