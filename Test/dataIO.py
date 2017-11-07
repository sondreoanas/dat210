import back_user
import back_event
import back_db as db
import time
import security
import notifications as n
import datetime
from flask import session

# getData
#

def getData(data, params=None,):
    functions = {
        'loadview': load_view,
        'nav': nav,
        'frontmenu': frontmenu,

        'login':login,
        'forgotpass':forgotpass,
        'newuser':newuser,
        'edit_user':edit_user,
        'loggout':loggout,

        'calendar_list':calendar_list,
        'calendar_new':calendar_new,
        'calendar_edit':calendar_edit,
        'calendar_edit_form':calendar_edit_form,

        'event_list':event_list,
        'event_calendar': event_calendar,
        'event_calendar_list':event_calendar_list,
        'event_new':event_new,
        'event_edit':event_edit,
        'event_edit_form':event_edit_form,

        'task_new':task_new
    }

    if data in functions:
        return functions[data](params)

""" HOME """    #----------------------------------------------

# LoadView
# Used to get Data for the home view

def load_view(params):
    cal_db = []
    if params['calendars'] is not None:
        cal_db = params['calendars']
    else:
        user_id = session['id']
        for cal_id, cal_name, cal_rights, cal_public in db.get_all_calendars_db(user_id):
            cal_db.append(cal_id)
    events = {'events':[]}
    start = datetime.datetime.fromtimestamp(params['load_start']/1000.0).isoformat()
    end = datetime.datetime.fromtimestamp(params['load_end']/1000.0).isoformat()
    for cal_id in cal_db:
        events_db = back_event.search_events_usercalendar(user_id,cal_id,start,end)
        if events_db:
            for event in events_db['search_results']:
                start_event = time.mktime(event['start'].timetuple()) * 1000
                end_event = time.mktime(event['end'].timetuple()) * 1000
                event = {
                    'start':start_event,
                    'end':end_event,
                    'name': event['name']
                }
                events['events'].append(event)
        else:
            continue
    return events

# Nav
# Used to get the format of the navigation bar when a user IS logged in

def nav(params):
        return {
                "items": {
                    "Home" : [0,"/home"],
                    "Calendar" : [1,{
                        "New Calendar" : [0,"calendar/new"],
                        "My Calendars" : [0,"calendar/list"],
                    }],
                    "Event" : [1,{
                        "New Event" : [0,"event/new"],
                        "My Events" : [0,"event/list"]
                    }],
                    "Tasks" : [1,{
                        "New Task" : [0,"task/new"],
                        "My Tasks" : [0,"task/list"]
                    }],
                    "Loggout" : [0,"/loggedout"]
                }
            }

# Front Menu
# Used to get the format of the navigation bar when a user IS NOT logged in

def frontmenu(params):
        return {
                "items": {
                    "Login" : [0,"/login"],
                    "New user" : [0,"/newuser"],
                    "Forgot password?" : [0,"/forgotpass"]
                }
            }

""" USER """    #----------------------------------------------

# Login
#

def login(params):
    result = back_user.login(params['username'],params['password'])
    if result['success']:
        session['id'] = result['user_id']
        session['username'] = params['username']
        session['login'] = True
        resultat = {
            "success": result['success'],
            "data": {
                "username" : params["username"]
            }
        }
    else:
        n.append(n.notification(1))
        resultat = {
                "notifications": n.flush(),
                "success": result['success'],
                "data": {
                    "username" : params["username"]
                }
        }
    return resultat

def newuser(params):
    user = {}
    user["data"] = {
        "email": params["email"],
        "nickname": params["nickname"]
    }
    if security.check_equal(params['password'],params['password_repeat']):
        result = back_user.register_user(params['email'], params['password'], params['nickname'])
        user["success"] = result
        if not result:
            n.append(n.notification(3))
    else:
        n.append(n.notification(2))
        user["success"] = False
    user["notifications"] = n.flush()
    return user

def forgotpass(params):
     return {
        "success": True,
        "data": {
            "username" : params["username"]
        }
    }

def edit_user(params):
    if params['password_repeat'] == params['password']:
        result = back_user.edit_user(params['username_old'],params['username'],params['password'],)
    else: result = False
    user = {
        "success":result,
        "data": {
            "username":params['username'],
            "name": params['name'],
        }
    }
    return user


def loggout(params):
    username = session['username']
    user = {
        "success": back_user.logout(),
        "data": {
            'username':username
        }
    }
    return user


""" CALENDAR """    #----------------------------------------------

def calendar_list(params):
    cal_db = db.get_all_calendars_db(session['id'])
    calendars = []
    for cal_id, cal_name, cal_rights, cal_public in cal_db:
        calendar = {
            "id": cal_id,
            "name": cal_name,
            "rights": cal_rights,
            "public": cal_public
        }
        calendars.append(calendar)
    if len(calendars) == 0:
        n.append(n.notification(4))
    return calendars

def calendar_new(params):
    if params['public'] == 'public':
        params['public'] = True
    else:
        params['public'] = False
    result = back_event.add_new_calendar(session['id'], params['name'],params['public'])

    calendar={}
    calendar["success"] = result[0]
    if result[0]:
        calendar["data"] = {
            "id" : result[1],
            "name" : params["name"],
            "public" : params["public"]
        }
    else:
        n.append(n.notification(5))
    calendar["notifications"] = n.flush()

    return calendar


def calendar_edit(params):
    result = db.get_calendar_db(session['id'],params['id'])
    calendar = {
        "success": True,
        "data": {
            "id": result[0],
            "name": result[1],
            "public": result[2]
        }
    }
    return calendar


def calendar_edit_form(params):
    if params['public'] == 'public':
        params['public'] = True
    else:
        params['public'] = False

    calendar = {
        "success": db.edit_calendar_db(session['id'],params['id'],params['name'],params['public']),
        "data": {
            "id" : params["id"],
            "name" : params['name'],
            "public" : params['public']
        }
    }
    if not calendar["success"]:
        n.append(n.notification(6))
    calendar["notifications"] = n.flush()
    return calendar



""" EVENT """    #----------------------------------------------

def event_calendar(params):
    return {"calendar_id": params["args"].get("calendar_id", 0)}


def event_calendar_list(params):
    calendar_id = params["args"].get("calendar_id", 0)
    calendar_events = db.get_all_calendar_events_db(calendar_id)
    returner = []
    for event_id, _ in calendar_events:
        event = db.get_event_db(event_id)
        event = {
            "id": event_id,
            "calendar_id": calendar_id,
            "name": event[1],
            "start": str(event[3]),
            "end": str(event[4])
        }
        returner.append(event)
    if len(returner) == 0:
        n.append(n.notification(7))
    return returner

def event_list(params):
    cal_db = db.get_all_calendars_db(session['id'])
    resultat = []
    for cal_id, cal_name, cal_rights, cal_public in cal_db:
        events_db = db.get_all_calendar_events_db(cal_id)
        for event_id,cal_id in events_db:
            id,name,des,start,end = db.get_event_db(event_id)
            event = {
                'id': event_id,
                'name': name,
                'start':str(start),
                'end':str(end)
            }
            resultat.append(event)
    if len(resultat) == 0:
        n.append(n.notification(7))
    return resultat

def event_new(params):

    start = datetime.datetime.strptime(params['start'],"%Y-%m-%dT%H:%M:%S.%fZ")
    end = datetime.datetime.strptime(params['end'],"%Y-%m-%dT%H:%M:%S.%fZ")

    result = back_event.add_new_event(params['calendar_id'],params['name'],start.isoformat(),end.isoformat())

    event = {
        "success": result['success'],
        "data": {
            "id" : result['event_id'],
            "calendar_id": params["calendar_id"],
            "name": params["name"],
            "start": time.mktime(start.timetuple()) * 1000,
            "end": time.mktime(end.timetuple()) * 1000
        }
    }

    if not result['success']:
        n.append(n.notification(8))
    event["notifications"] = n.flush()
    return event

def event_edit_form(params):
    event_form = {
        "success": db.edit_event_db(params['id'], params['name'], None, params['start'], params['end'], None, None),
        #event description mangler + intervall + terminate_date
        "data": {
            "id" : params["id"],
            "calendar_id": params["cal_id"],
            "calendars" : getData("calendar_list"),
            "name": params['name'],
            "start": params['start'],
            "end":  params['end']
        }
    }
    if not event_form['success']:
        n.append(n.notification(9, {"id": params["id"]}))
    event_form["notifications"] = n.flush()
    return event_form

def event_edit(params):
    result = db.get_event_db(params["args"].get("event_id", 0))
    event = {
        "notifications":n.flush(),
        "success": True,
        "data": {
            "id" : params["id"],
            "calendar_id": result[0],
            "calendars" : getData("calendar_list"),
            "name": result[1],
            "start": str(result[2]),
            "end":  str(result[3])
        }
    }
    return event



""" TASKS """    #----------------------------------------------

def task_new(params):

    calendar_id = params.get('form_task_calendar', 0)
    name = params.get('form_task_name', 0)

    interval = {}
    temp = {}

    temp["interval_type"] = params.get('form_task_interval_type', 0)

    temp["interval_type_year"] = params.get('form_task_interval_type_year', 0)
    temp["interval_type_month"] = params.get('form_task_interval_type_month', 0)
    temp["interval_type_week"] = params.get('form_task_interval_type_week', 0)
    temp["interval_type_month_year"] = params.get('form_task_interval_type_month_year', 0)
    temp["interval_type_week_year"] = params.get('form_task_interval_type_week_year', 0)
    temp["interval_type_week_month"] = params.get('form_task_interval_type_week_month', 0)

    temp["interval_year"] = params.get('form_task_interval_year', 0)
    temp["interval_month"] = params.get('form_task_interval_month', 0)
    temp["interval_week"] = params.get('form_task_interval_week', 0)
    temp["interval_day"] = params.get('form_task_interval_day', 0)
    temp["interval_month_year"] = params.get('form_task_interval_month_year', 0)
    temp["interval_week_year"] = params.get('form_task_interval_week_year', 0)
    temp["interval_day_year"] = params.get('form_task_interval_day_year', 0)
    temp["interval_week_month"] = params.get('form_task_interval_week_month', 0)
    temp["interval_day_month"] = params.get('form_task_interval_day_month', 0)
    temp["interval_day_week"] = params.get('form_task_interval_day_week', 0)

    for element in temp:
        if temp[element] != 0 and temp[element] != "0":
            interval[element] = temp[element]

    todos = params.getlist('todos')
    user_id = session['id']

    result = back_event.add_new_task(user_id, name, None, None, None, calendar_id)
    
    returner = {
        "success": result["task_id"],
        "data": {
            "id" : result["task_id"],
            "calendar_id": calendar_id,
            "name": name,
            "todos": todos,
            "interval": interval
        }
    }

    return returner
