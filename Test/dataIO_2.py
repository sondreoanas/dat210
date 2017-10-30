import back_user
import back_event
import back_db as db
import security
import time
import datetime
from flask import session

def getData(data, params=None,):
    functions = {
        'loadview': load_view,
        'nav': nav,

        'login':login,
        'forgotpass':forgotpass,
        'newuser':newuser,
        'edit_user':edit_user,
        'logout':logout,

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

def load_view(params):
    cal_db = db.get_all_calendars_db(session['id'])
    events = {'events':[]}
    if cal_db:
        for cal_id, cal_name, cal_rights, cal_public in cal_db:
            events_db = db.get_all_calendar_events_db(cal_id)
            if events_db:
                for event_id,cal_id in events_db:
                    event_db = db.get_event_db(event_id)
                    start = time.mktime(event_db[3].timetuple()) * 1000
                    end = time.mktime(event_db[4].timetuple()) * 1000
                    if event_db:
                        event = {
                            'id': event_id,
                            'name': event_db[1],
                            'start':start,
                            'end':end
                        }
                        events['events'].append(event)
                    else:
                        return {'success':False}
            else:
                return {'success':False}
    else:
        return {'success':False}
    return events

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
                "Loggout" : [0,"/loggedout"]
            }
        }



""" USER """    #----------------------------------------------

def login(params):
    resultat = {
        "success": back_user.login(params['username'],params['password']),
        "data": {
            "username" : params["username"]
        }
    }
    return resultat

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

def logout(params):
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
    if cal_db:
        for cal_id, cal_name, cal_rights, cal_public in cal_db:
            calendar = {
                "id": cal_id,
                "name": cal_name,
                "rights": cal_rights,
                "public": cal_public
            }
            calendars.append(calendar)
        return calendars
    else:
        return {'success':False}

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
    result = db.get_calendar_db(params['id'])
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
        "success": db.edit_calendar_db(params['id'],params['name'],params['public']),
        "data": {
            "id" : params["id"],
            "name" : params['name'],
            "public" : params['public']
        }
    }
    return calendar



""" EVENT """   #----------------------------------------------

def event_list(params):
    cal_db = db.get_all_calendars_db(session['id'])
    resultat = []
    if cal_db:
        for cal_id, cal_name, cal_rights, cal_public in cal_db:
            calendar = {cal_id:[]}
            events_db = db.get_all_calendar_events_db(cal_id)
            if events_db:
                for event_id,cal_id in events_db:
                    event_db = db.get_event_db(event_id)
                    if event_db:
                        event = {
                            'id': event_id,
                            'name': event_db[1],
                            'start':str(event_db[3]),
                            'end':str(events_db[4])
                        }
                        calendar[cal_id].append(event)
                    else:
                        return {'success':False}
            else:
                return {'success':False}
        resultat.append(calendar)
    else:
        return {'success':False}
    return resultat

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


