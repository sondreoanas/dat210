import unittest
from back_user import *
from logged_in_user import *
from test_user import *
from back_event import *
from back_db import *
import config as c
from datetime import date, datetime

nr_of_cals = 1
nr_of_userevents = 6
cal_ids = [
    1001,
    1002,
    1003,
    1004,
    1005,
    1006,
    1007,
    1008,
    1009,
    1010,
    1011,
    1012,
    1013,
    1014,
    1015,
    1017,
    1018,
    1019,
    1020,
    1021,
    1022,
    1023,
    1024,
    1025,
    1026,
    1027,
    1028,
    1029,
    1030,
    1031,
    1032,
    1033,
    1034,
    1035,
    1036,
    1037,
    1038,
    1039,
    1040,
    1041,
    1042,
    1043,
    1044,
    1045,
    1046,
    1047,
    1048,
    1049,
    1050,
    1051,
    1052,
    1053,
    1054,
    1055,
    1056,
    1057,
    1058,
    1059,
    1060,
    1061,
    1062,
    1063,
    1064,
    1065,
    1066,
    1067,
    1068,
    1069,
    1070,
    1071,
    1072,
    1073,
    1074,
    1075,
    1076,
    1077,
    1078,
    1079,
    1080,
    1081,
    1082,
    1083,
    1084,
    1085,
    1086,
    1087,
    1088,
    1089,
    1090,
    1091,
    1092,
    1093,
    1094,
    1095,
    1096,
    1097,
    1098,
    1099,
    1100,
]
eve_ids = [
    22501,
    22502,
    22503,
    22504,
    22505,
    22506,
    22507,
    22508,
    22509,
    22510,
    22511,
    22512,
    22513,
    22514,
    22515,
    22516,
    22517,
    22518,
    22519,
    22520,
    22521,
    22522,
    22523,
    22524,
    22525,
    22526,
    22527,
    22528,
    22529,
    22530,
    22531,
    22532,
    22533,
    22534,
    22535,
    22536,
    22537,
    22538,
    22539,
    22540, 
    22541, 
    22542, 
    22543, 
    22544, 
    22545, 
    22546, 
    22547, 
    22548, 
    22549, 
    22550, 
    22551, 
    22552, 
    22553, 
    22554, 
    22555, 
    22556, 
    22557, 
    22558, 
    22559, 
    22560, 
    22561, 
    22562, 
    22563, 
    22564, 
    22565, 
    22566, 
    22567, 
    22568, 
    22569, 
    22570, 
    22571, 
    22572, 
    22573, 
    22574, 
    22575, 
    22576, 
    22577, 
    22578, 
    22579, 
    22580, 
]
task_ids = [
    181,
    182,
    183,
    184,
    185,
    186,
    187,
    188,
    189,
    190,
    191,
    192,
    193,
    194,
    195,
    196,
    197,
    198,
    199,
    200,
    201,
    202,
    203,
    204,
    205,
    206,
    207,
    208,
    209,
    210,
    211,
    212,
    213,
    214,
    215,
    216,
    217,
    218,
    219,
    220,
]
search_parameters = {
    'calendar_id': 302,
    'start': datetime(2017, 8, 14, 0, 0, 0).isoformat(),
    'end': datetime(2018, 5, 6, 0, 0, 0).isoformat(),
    'user_id': 1201
}
results = [
    {
        'event_id': 3,
        'start': datetime(2017, 8, 14, 0, 0, 0),
        'end': datetime(2017, 9, 26, 0, 0, 0)
    },
    {
        'event_id': 2301,
        'start': datetime(2018, 3, 18, 0, 0, 0),
        'end': datetime(2018, 5, 6, 0, 0, 0)
    },
    {
        'event_id': 3472,
        'start': datetime(2018, 1, 25, 0, 0, 0),
        'end': datetime(2018, 1, 27, 0, 0, 0)
    },
    {
        'event_id': 19621,
        'start': datetime(2018, 4, 9, 0, 0, 0),
        'end': datetime(2018, 4, 29, 0, 0, 0)
    },
    {
        'event_id': 19765,
        'start': datetime(2018, 2, 7, 0, 0, 0),
        'end': datetime(2018, 4, 14, 0, 0, 0)
    }
]


class UsercalendarTest(unittest.TestCase):
    def test_00_get_user_calendars(self):
        with app.app_context():
            login_testuser()
            usercalendars = c.the_user.get_user_calendars()
            self.assertEqual(len(usercalendars), nr_of_cals)

    def test_01_get_all_userevents(self):
        with app.app_context():
            userevents = c.the_user.get_user_events()
            self.assertEqual(len(userevents), nr_of_userevents)

    def test_50_get_user_calendars(self):
        with app.app_context():
            logout()
            usercalendars = c.the_user.get_user_calendars()
            self.assertEqual(usercalendars, False)

    def test_51_get_all_userevents(self):
        with app.app_context():
            userevents = c.the_user.get_user_events()
            self.assertEqual(userevents, False)

class AddcalendarTest(unittest.TestCase):
    def test_00_add_calendar(self):
        with app.app_context():
            login_testuser()
            self.assertIn(add_new_calendar_db(0), cal_ids)

    def test_01_add_usercalendar(self):
        with app.app_context():
            self.assertIn(add_new_calendar(1), cal_ids)

    def test_02_add_event(self):
        with app.app_context():
            now = date.today()
            self.assertIn(add_new_event_db(now), eve_ids)

    def test_03_add_eventcalendar(self):
        with app.app_context():
            now = date.today()
            self.assertIn(add_new_event(now, cal_ids[3]), eve_ids)

    def test_04_add_task(self):
        with app.app_context():
            self.assertIn(add_new_task_db('a'), task_ids)

    def test_06_add_usertask(self):
        with app.app_context():
            self.assertIn(add_new_task('a'), task_ids)

    def test_05_add_eventtask(self):
        with app.app_context():
            self.assertEqual(add_new_usertask_db(184, 1201), True)

    def test_07_add_child_task(self):
        with app.app_context():
            self.assertEqual(True, True)

class SearchintervalTest(unittest.TestCase):
    def test_01_add_calendar(self):
        with app.app_context():
            login_testuser()
            self.assertListEqual(search_events_usercalendar(search_parameters['calendar_id'], search_parameters['start'], search_parameters['end']), results)

def main():
    unittest.main()

if __name__ == '__main__':
    main()
