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

    def set_user_calendars(self, calendar_id, calendar_rights):
        if 'calendars' not in self.__the_user.keys():
            self.__the_user['calendars'] = dict()
        self.__the_user['calendars'][calendar_id] = dict()
        self.__the_user['calendars'][calendar_id]['calendar_rights'] = calendar_id

    def get_user_calendars(self):
        if 'calendars' in self.__the_user.keys():
            return self.__the_user['calendars']
        return False

    def clear(self):
        """clears the class"""
        self.__the_user = LoggedInUser(dict())

    def contents(self):
        """return the details of the logged in user"""
        return self.__the_user
