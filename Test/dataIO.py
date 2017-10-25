import back_user
import back_event
import config as c
import time
import notifications as n
import datetime



def getData(data, params=None,):
    returner = {}


    if data == 'loadview':
        events_db = c.the_user.get_user_events()

        returner = {'events':[]}
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
            returner['events'].append(event)
        """
        events_db = c.the_user.get_user_events()
        returner = {'events': []}
        for event_id in events_db:
            if 'events' in cal_db[cal_id].keys():
                for event_id in cal_db[cal_id]['events']:
                    start = cal_db[cal_id]['events'][event_id]['start']
                    end = cal_db[cal_id]['events'][event_id]['end']

                    start = time.mktime(start.timetuple()) * 1000
                    end = time.mktime(end.timetuple()) * 1000


                    event = {
                        'id': event_id,
                        'start': start,
                        'end': end,
                        'name': cal_db[cal_id]['events'][event_id]['name']
                    }
                    returner['events'].append(event)
        """


    if data == "login":
        result = back_user.login(params['username'],params['password'])
        if result:
            returner = {
                "success": result,
                "data": {
                    "username" : params["username"]
                }
            }
        else:
            returner = {
                "notifications": [n.notification(1)],
                "success": result,
                "data": {
                    "username" : params["username"]
                }
            }

    if data == "forgotpass":
        returner = {
            "success": True,
            "data": {
                "username" : params["username"]
            }
        }

    if data == "nav":
        returner = {
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

    if data == "frontmenu":
        returner = {
                "items": {
                    "Login" : [0,"/login"],
                    "New user" : [0,"/newuser"],
                    "Forgot password?" : [0,"/forgotpass"]
                }
            }

    if data == "calendar_list":

        #returner = [
        #    [21, "Calendar 01",True],
        #    [5454, "Calendar 02",False],
        #    [554, "Calendar 03",True],
        #    [4545, "Calendar 04",False]
        #]
        cal_db = c.the_user.get_user_calendars()
        returner = []
        for cal_id in cal_db:
            calendar = {
                "id": cal_id,
                "name": cal_db[cal_id]['calendar_name'],
                "rights": cal_db[cal_id]['calendar_rights'],
                "public": cal_db[cal_id]['calendar_public']
            }
            returner.append(calendar)

    if data == "event_list":
        #returner = [
        #    [4545, "Event 01","October 17, 2017 12:00","October 26, 2017 12:00"],
        #    [45, "Event 02","October 17, 2017 12:00","October 26, 2017 12:00"],
        #    [54, "Event 03","October 17, 2017 12:00","October 26, 2017 12:00"],
        #     [454, "Event 04","October 17, 2017 12:00","October 26, 2017 12:00"]
        #]


        events_db = c.the_user.get_user_events()

        returner = []
        for event_id in events_db:
            event = c.the_user.get_user_event(event_id)
            event = {
                "id": event_id,
                "name": event[1],
                "start": str(event[3]),
                "end": str(event[4])
            }
            returner.append(event)


#### PUT DATA #####

    if data == "newuser":
        if params['password'] == params['password_repeat']:
            result = back_user.register_user(params['email'], params['password'], params['nickname'])
        else:
            result = False
        returner = {
            "success": result,
            "data": {
                "email": params["email"],
                "nickname": params["nickname"]
            }
        }
    if data == "edit_user":
        if params['password_repeat'] == params['password']:
            result = back_user.edit_user(params['username_old'],params['username'],params['password'],)
        else: result = False
        returner = {
            "success":result,
            "data": {
                "username":params['username'],
                "name": params['name'],
            }
        }


    if data == "calendar_new":
        if params['public'] == 'public':
            params['public'] = True
        else:
            params['public'] = False
        result = back_event.add_new_calendar(params['name'],params['public'])
        if result[0]:
            returner = {
                "success": result[0],
                "data": {
                    "id" : result[1],
                    "name" : params["name"],
                    "public" : params["public"]
                }
            }
        else:
            returner = {
                "success": result[0]
            }
    if data == "calendar_edit":
        result = c.the_user.get_calendar(params['id'])
        returner = {
            "success": True,
            "data": {
                "id": result[0],
                "name": result[1],
                "public": result[2]
            }
        }


    if data == "calendar_edit_form":
        if params['public'] == 'public':
            params['public'] = True
        else:
            params['public'] = False
        returner = {
            "success": back_event.edit_calendar(params['id'],params['name'],params['public']),
            "data": {
                "id" : params["id"],
                "name" : params['name'],
                "public" : params['public']
            }
        }

    if data == "event_new":
        start = datetime.datetime.strptime(params['start'],"%Y-%m-%dT%H:%M:%S.%fZ").isoformat()
        end = datetime.datetime.strptime(params['end'],"%Y-%m-%dT%H:%M:%S.%fZ").isoformat()
        result = back_event.add_new_event(params['calendar_id'],params['name'],start,end)
        returner = {
            "success": result[1],
            "data": {
                "id" : result[0],
                "calendar_id": params["calendar_id"],
                "name": params["name"],
                "start": params['start'],
                "end": params['end']
            }
        }

    if data == "event_edit_form":
        returner = {
            "success": back_event.edit_event(params['id'], params['name'], 0, params['start'], params['end'], 0, 0),
            #event description mangler + intervall + terminate_date
            "data": {
                "id" : params["id"],
                "calendar_id": params["calendar_id"],
                "calendars" : getData("calendar_list"),
                "name": params['name'],
                "start": params['start'],
                "end":  params['end']
            }
        }

    if data == "event_edit":
        #MANGLER calendar_id, gir nå event_id
        result = c.the_user.get_user_event(params['id'])
        returner = {
            "success": True,
            "data": {
                "id" : params["id"],
                "calendar_id": result[0],
                "calendars" : getData("calendar_list"),
                "name": result[1],
                "start": str(result[3]),
                "end":  str(result[4])
            }
        }

    if data == "loggout":
        returner = {
            "success": back_user.logout()
        }

    return returner
