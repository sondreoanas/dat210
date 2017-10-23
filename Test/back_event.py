"""Calendar and events"""
import back_user
import back_db as db
import config as c

"""def init_all_calendars():
    calendars = db.get_all_calendars_db(c.the_user.get_userid())
    print(calendars)
    if calendars:
        for (cal_id, cal_name, cal_rigts, cal_public) in calendars:
            c.the_user.set_user_calendars(cal_id, cal_name, cal_rigts, cal_public)

def init_all_userevents():
    init_userevents(c.the_user.get_user_calendars())

def init_userevents(calendars):
    if calendars:
        for calendar_id in calendars:
            calendar_events = db.get_all_calendar_events_db(calendar_id)
            if calendar_events:
                for (event_id, cal_id) in calendar_events:
                    event = db.get_event_db(event_id)
                    if event:
                        c.the_user.set_user_events(cal_id, event_id, event[1], event[2], event[3], event[0], event[0])
"""
def add_new_calendar(calendar_name, public_bool):
    calendar_id = db.add_new_calendar_db(calendar_name, public_bool)
    if calendar_id:
        if db.add_new_usercalendar_db(calendar_id):
            calendar = db.get_calendar_db(c.the_user.get_userid, calendar_name, calendar_id)
            c.the_user.set_user_calendars(calendar[0], calendar[1])
            return [calendar_id, True]
    return False

def edit_calendar(calendar_id, calendar_name, public_bool):
    return db.edit_calendar_db(calendar_id, calendar_name, public_bool)

def add_new_event(calendar_id, event_name, start_time, end_time):
    event_id = db.add_new_event_db(event_name, start_time, end_time)
    if event_id:
        if db.add_new_eventcalendar_db(event_id, calendar_id):
            event = db.get_event_db(event_id)
            c.the_user.set_user_events(calendar_id, event_id)
            return [event_id, True]
    return False

def edit_event(event_id, event_name, event_description, event_start, event_end, event_interval, event_terminatedate):
    return db.edit_event_db(event_id, event_name, event_description, event_start, event_end, event_interval, event_terminatedate)

def add_new_task(interval):
    task_id = db.add_new_task_db(interval)
    if task_id:
        if db.add_new_usertask_db(task_id, c.the_user.get_userid()):
            return task_id
    return False

def search_events_usercalendar(calendar_id, interval_start, interval_end):
    events = db.get_events_usercalendar_interval(the_user.get_userid, calendar_id, interval_start, interval_end)
    if events != False:
        search_results = []
        search_result = dict()
        for event in events:
            search_result = {
                'event_id': event[0],
                'start': event[1],
                'end': event[2]
            }
            search_results.append(search_result.copy())
        return search_results
    return events
