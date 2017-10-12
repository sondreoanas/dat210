"""Calendar and events"""
from back_user import *
from logged_in_user import *
from back_db import *

def get_all_calendars():
    calendars = get_all_calendars_db(the_user.get_userid())
    if calendars:
        for (cal_id, cal_rigts) in calendars:
            the_user.set_user_calendars(cal_id,cal_rigts)