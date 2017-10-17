"""Calendar and events"""
from back_user import *
from logged_in_user import *
from back_db import *

def get_all_calendars():
    calendars = get_all_calendars_db(the_user.get_userid())
    if calendars:
        for (cal_id, cal_rigts) in calendars:
            the_user.set_user_calendars(cal_id,cal_rigts)

def get_all_userevents():
    get_userevents(the_user.get_user_calendars())

def get_userevents(calendars):
    for calendar_id in calendars:
        calendar_events = get_all_calendar_events_db(calendar_id)
        if calendar_events:
            for (event_id, cal_id) in calendar_events:
                event = get_event_db(event_id)
                if event:
                    the_user.set_user_events(cal_id, event_id, event[1], event[2], event[0], event[0])  
                    
def add_new_calendar(public_bool):
    calendar_id = add_new_calendar_db(public_bool)
    if calendar_id:
        if add_new_usercalendar_db(calendar_id):
            return calendar_id
    return False

def add_new_event(start_time, calendar_id):
    event_id = add_new_event_db(start_time)
    if event_id:
        if add_new_eventcalendar_db(event_id, calendar_id):
            return event_id
    return False

def add_new_task(interval):
    task_id = add_new_task_db(interval)
    if task_id:
        if add_new_usertask_db(task_id, the_user.get_userid()):
            return task_id
    return False
