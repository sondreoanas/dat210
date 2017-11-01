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
        'event_new':event_new,
        'event_edit':event_edit,
        'event_edit_form':event_edit_form
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
        resultat = {
                "notifications": [n.notification(1)],
                "success": result['success'],
                "data": {
                    "username" : params["username"]
                }
        }
    return resultat

def newuser(params):
    result = back_user.register_user(params['email'], params['password'], params['nickname'])
    user = {}
    if security.check_equal(params['password'],params['password_repeat']):
        if result:
            user = {
                "success": result,
                "data": {
                    "email": params["email"],
                    "nickname": params["nickname"]
                }
            }
        else:
            user = {
                "success": result,
                "data": {
                    "email": params["email"],
                    "nickname": params["nickname"]
                }
            }
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
    return calendars

def calendar_new(params):
    if params['public'] == 'public':
        params['public'] = True
    else:
        params['public'] = False
    result = back_event.add_new_calendar(session['id'], params['name'],params['public'])
    calendar = {
        "success": result[0],
        "data": {
            "id" : result[1],
            "name" : params["name"],
            "public" : params["public"]
        }
    }
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
            "success": db.edit_calendar_db(params['id'],params['name'],params['public']),
            "data": {
                "id" : params["id"],
                "name" : params['name'],
                "public" : params['public']
            }
    }
    return calendar

def calendar_new(params):
    if params['public'] == 'public':
        params['public'] = True
    else:
        params['public'] = False
    result = back_event.add_new_calendar(session['id'], params['name'],params['public'])
    calendar = {
        "success": result['success'],
        "data": {
            "id" : result['calendar_id'],
            "name" : params["name"],
            "public" : params["public"]
        }
    }
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
    return resultat

def event_new(params):
    print(params['start'])
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
    return event_form

def event_edit(params):
    result = db.get_event_db(params['id'])
    event = {
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

def task_new(params):
    calendar_id = params.get('form_task_calendar', 0)
    name = params.get('form_task_name', 0)
    start = params.get('form_task_start', 0)
    todos = params.getlist('todos')

    returner = {
        "success": True,
        "data": {
            "id" : 1,
            "calendar_id": calendar_id,
            "name": name,
            "start": start,
            "todos": todos
        }
    }
