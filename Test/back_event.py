"""Calendar and events"""
import back_db as db


def add_new_calendar(user_id,calendar_name, public_bool):
    """returns the dict:
    \"success\": bool,
    \"calendar_id\": calendar_id
    """

    calendar_id = db.add_new_calendar_db(calendar_name, public_bool)
    if calendar_id:
        if db.add_new_usercalendar_db(user_id,calendar_id):
            return {"success": True, "calendar_id": calendar_id}
    return {"success": False}

def edit_calendar(user_id, calendar_id, calendar_name, public_bool):
    """returns the dict:
    \"success\": bool

    denne funksjonen kan redudant og edit_calendar_db kan kalles
    direkte og vil enten returnere True eller false
    """
    return {"success": db.edit_calendar_db(user_id, calendar_id, calendar_name, public_bool)}

def add_new_event(calendar_id, event_name, start_time, end_time):
    """returns the dict:
    \"success\": bool,
    \"event_id\": event_id
    """
    event_id = db.add_new_event_db(event_name, start_time, end_time)
    if event_id:
        try:
            calendar_id = int(calendar_id)
            if db.add_new_eventcalendar_db(event_id, calendar_id):
                return {"success": True, "event_id": event_id}
            else:
                db.delete_event_db(event_id)
        except ValueError:
            db.delete_event_db(event_id)
    return {"success": False}

def edit_event(user_id, old_calendar_id, new_calendar_id, event_id, event_name, event_description, event_start, event_end, event_interval, event_terminatedate):
    """returns the dict:
    \"success\": bool

    denne funksjonen er redudant og kan funksjonen edit_event_db kan kalle direkte
    edit_event_db returnerer True eller False
    """
    return {"success": db.edit_event_db(user_id, old_calendar_id, new_calendar_id, event_id, event_name, event_description, event_start, event_end, event_interval, event_terminatedate)}

def add_new_task(user_id, name, description, start_date, timestamp, calendar_id):
    """returns the dict:
    \"success\": bool,
    \"task_id\": task_id
    """
    task_id = db.add_new_task_db(name, description, start_date, timestamp, calendar_id)
    if task_id:
        if db.add_new_usertask_db(task_id, user_id):
            return {"success": True, "task_id": task_id}
    return {"success": False}


def search_events_usercalendar(user_id, calendar_id, interval_start, interval_end):
    """returns the dict:
    \"success\": bool,
    \"search_results\": [
        {\"event_name\": event_name, \"event_id\": event_is, \"\": start, \"\": end},
        {\"event_name\": event_name, \"event_id\": event_is, \"\": start, \"\": end},
        {\"event_name\": event_name, \"event_id\": event_is, \"\": start, \"\": end},
        ...
        ...
        ]
    """
    events = db.get_events_usercalendar_interval(user_id, calendar_id, interval_start, interval_end)
    if events != False:
        search_results = []
        search_result = dict()
        for event in events:
            search_result = {
                'name': event[0],
                'start': event[2],
                'end': event[3]
            }
            search_results.append(search_result.copy())
        return {"success": True, "search_results": search_results}
    return {"success": False}
