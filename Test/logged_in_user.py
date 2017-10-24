"""Class representing the logged in user"""
import back_db as db

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
        """retrieves the name of the user"""
        if 'name' in self.__the_user.keys():
            return self.__the_user['name']
        return False

    def set_userid(self, userid):
        """sets the userid"""
        self.__the_user['id'] = userid

    def get_userid(self):
        """retrieves the id of the logged in user"""
        if 'id' in self.__the_user.keys():
            return self.__the_user['id']
        return False

    """
    def set_user_calendars(self, calendar_id, calendar_name, calendar_rights, calendar_public):
        if 'calendars' not in self.__the_user.keys():
            self.__the_user['calendars'] = dict()
        self.__the_user['calendars'][calendar_id] = dict()
        self.__the_user['calendars'][calendar_id]['calendar_rights'] = calendar_rights
        self.__the_user['calendars'][calendar_id]['calendar_name'] = calendar_name
        self.__the_user['calendars'][calendar_id]['calendar_public'] = calendar_public
    """

    def get_user_calendars(self):
        calendars = db.get_all_calendars_db(self.get_userid())
        print(calendars)
        calendar_list = dict()
        if calendars:
            for (cal_id, cal_name, cal_rigts, cal_public) in calendars:
                calendar_list[cal_id] = dict()
                calendar_list[cal_id]['calendar_rights'] = cal_name
                calendar_list[cal_id]['calendar_name'] = cal_name
                calendar_list[cal_id]['calendar_public'] = cal_public
            return calendar_list
        return False

    """
    def set_user_events(self, calendar_id, event_id, name, start, end, interval, terminatedate):
        if 'events' not in self.__the_user['calendars'][calendar_id].keys():
            self.__the_user['calendars'][calendar_id]['events'] = dict()
        self.__the_user['calendars'][calendar_id]['events'][event_id] = dict()
        self.__the_user['calendars'][calendar_id]['events'][event_id]['name'] = name
        self.__the_user['calendars'][calendar_id]['events'][event_id]['start'] = start
        self.__the_user['calendars'][calendar_id]['events'][event_id]['end'] = end
        self.__the_user['calendars'][calendar_id]['events'][event_id]['interval'] = interval
        self.__the_user['calendars'][calendar_id]['events'][event_id]['terminatedate'] = terminatedate
    """

    def get_user_events(self):
        calendars = self.get_user_calendars()
        calendar = dict()
        user_events = []
        if calendars:
            for calendar_id in calendars:
                calendar_events = db.get_all_calendar_events_db(calendar_id)
                calendar[calendar_id] = dict()
                if calendar_events:
                    for (event_id, cal_id) in calendar_events:
                        event = db.get_event_db(event_id)
                        if event:
                            if 'events_list' not in calendar[calendar_id]:
                                calendar[calendar_id]['events_list'] = []
                            calendar[calendar_id]['events_list'].append(event_id)
                            user_events.append(event_id)
            return user_events
        return user_events

    def get_user_event(self, calendar_id, event_id):
        pass

    def clear(self):
        """clears the class"""
        self.__the_user = LoggedInUser(dict())

    def contents(self):
        """return the details of the logged in user"""
        return self.__the_user
