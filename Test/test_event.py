import unittest
from back_user import *
from logged_in_user import *
from test_user import *
from back_event import *

nr_of_cals = 7
nr_of_userevents = 50

class UsercalendarTest(unittest.TestCase):
    def test_00_get_user_calendars(self):
        with app.app_context():
            login_testuser()
            usercalendars = the_user.get_user_calendars()
            self.assertEqual(len(usercalendars), nr_of_cals)

    def test_01_get_all_userevents(self):
        with app.app_context():
            userevents = the_user.get_all_userevents()
            self.assertEqual(len(userevents), nr_of_userevents)

    def test_50_get_user_calendars(self):
        with app.app_context():
            logout()
            usercalendars = the_user.get_user_calendars()
            self.assertEqual(len(usercalendars), False)

    def test_51_get_all_userevents(self):
        with app.app_context():
            userevents = the_user.get_all_userevents()
            self.assertEqual(len(userevents), False)

def main():
    unittest.main()

if __name__ == '__main__':
    main()
