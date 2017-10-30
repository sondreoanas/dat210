import back_user
import back_event
import config as c
import security
import time
import datetime

def getData(data, params=None,):
    functions = {
        'loadview': load_view,
        'nav': nav,

        'login':login,
        'forgotpass':forgotpass,
        'newuser':newuser,
        'edit_user':edit_user,

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
        functions[data](params)


""" HOME """    #----------------------------------------------

def load_view():
    events_db = c.the_user.get_user_events()
    events = {'events':[]}
    for event_id in events_db:
        event = c.the_user.get_user_event(event_id)
        start = time.mktime(event[3].timetuple()) * 1000
        end = time.mktime(event[4].timetuple()) * 1000
        event = {
            "id": event_id,
            "name": event[1],
            "start": start,
            "end": end
        }
        events['events'].append(event)
    return events

def nav():
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
                "Loggout" : [0,"/loggedout"]
            }
        }



""" USER """    #----------------------------------------------

def login(params):
    return {
        "success": back_user.login(params['username'],params['password']),
        "data": {
            "username" : params["username"]
        }
    }

def forgotpass(params):
     return {
        "success": True,
        "data": {
            "username" : params["username"]
        }
    }

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

def loggout():
    user = {
        "success": back_user.logout()
    }
    return user

""" CALENDAR """    #----------------------------------------------

def calendar_list(params):
    cal_db = c.the_user.get_user_calendars()
    calendars = []
    for cal_id in cal_db:
        calendar = {
            "id": cal_id,
            "name": cal_db[cal_id]['calendar_name'],
            "rights": cal_db[cal_id]['calendar_rights'],
            "public": cal_db[cal_id]['calendar_public']
        }
        calendars.append(calendar)
    return calendars

def calendar_new(params):
    if params['public'] == 'public':
        params['public'] = True
    else:
        params['public'] = False
    result = back_event.add_new_calendar(params['name'],params['public'])
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
    result = c.the_user.get_calendar(params['id'])
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
    calendar = {
        "success": back_event.edit_calendar(params['id'],params['name'],params['public']),
        "data": {
            "id" : params["id"],
            "name" : params['name'],
            "public" : params['public']
        }
    }
    return calendar



""" EVENT """   #----------------------------------------------

def event_list():
    events_db = c.the_user.get_user_events()
    events = []
    for event_id in events_db:
        event = c.the_user.get_user_event(event_id)
        event = {
            "id": event_id,
            "name": event[1],
            "start": str(event[3]),
            "end": str(event[4])
        }
        events.append(event)
    return events

def event_new(params):
    start = datetime.datetime.strptime(params['start'],"%Y-%m-%dT%H:%M:%S.%fZ").isoformat()
    end = datetime.datetime.strptime(params['end'],"%Y-%m-%dT%H:%M:%S.%fZ").isoformat()
    result = back_event.add_new_event(params['calendar_id'],params['name'],start,end)
    event = {
        "success": result[1],
        "data": {
            "id" : result[0],
            "calendar_id": params["calendar_id"],
            "name": params["name"],
            "start": params['start'],
            "end": params['end']
        }
    }
    return event

def event_edit_form(params):
    event_form = {
        "success": back_event.edit_event(params['id'], params['name'], 0, params['start'], params['end'], 0, 0),
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
    result = c.the_user.get_user_event(params['id'])
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


