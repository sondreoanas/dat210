import back_user
import back_event
import config as c
import time
import datetime



def getData(data, params=None,):
    returner = {}

    back_user.login("ola@nordmann.no","p")


    if data == 'loadview':
        cal_db = c.the_user.get_user_calendars()
        returner = {'events': []}
        for cal_id in cal_db:
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



    if data == "login":

        returner = {
            "success": back_user.login(params['username'],params['password']),
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
                    }]
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

        cal_db = c.the_user.get_user_calendars()

        returner = []
        for cal_id in cal_db:
            if 'events' in cal_db[cal_id].keys():
                for event_id in cal_db[cal_id]['events']:
                    event = {
                        "id": event_id,
                        "name": cal_db[cal_id]['events'][event_id]['name'],
                        "start": str(cal_db[cal_id]['events'][event_id]['start']),
                        "end": str(cal_db[cal_id]['events'][event_id]['end'])
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
        result = back_event.add_new_calendar(params['name'],params['public'])
        returner = {
            "success": result[1],
            "data": {
                "id" : result[0],
                "name" : params["name"],
                "public" : params["public"]
            }
        }

    if data == "calendar_edit":
        returner = {
            "success": back_event.edit_calendar(params['id'],params['name'],params['public']),
            "data": {
                "id" : params["id"],
                "name" : params['name'],
                "public" : params['public']
            }
        }

    if data == "event_new":
        start = datetime.datetime.strptime(params['start'],"%Y-%m-%dT%H:%M:%S.%fZ")
        end = datetime.datetime.strptime(params['end'],"%Y-%m-%dT%H:%M:%S.%fZ")
        result = back_event.add_new_event(params['calendar_id'],params['name'],start.isoformat(),end.isoformat())
        returner = {
            "success": result[1],
            "data": {
                "id" : result[0],
                "calendar_id": params["calendar_id"],
                "name": params["name"],
                "start": params["start"],
                "end": params["end"]
            }
        }

    if data == "event_edit":
        returner = {
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

    return returner
