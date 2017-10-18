import back_user
import config as c
import time



def getData(data, params=None,):
    returner = {}

    """calendars {
            cal_id: {
                "calendar_rights": value,
                "events_list": [id, id, id, id ...],
                "events": {
                    event_id: {
                        "start": value,
                        "end": value,
                        "interval": value,
                        "terminatedate": value
                    }
                }
            }
        }
"""


    if data == 'loadview':
        cal_db = c.the_user.get_user_calendars()
        returner = {'events': []}
        cal_id = 1
        # for cal_id in cal_db:
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
        Success = back_user.login(params['username'],params['password'])
        if Success:
            returner = {
                "success": True,
                "data": {
                    "username" : params["username"]
                }
            }
        else: return False

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
            name = cal_db[cal_id]['calendar_name']
            rights = cal_db[cal_id]['calendar_rights']
            calendar = [cal_id,name,rights]
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
        cal_id = 1
        # for cal_id in cal_db:
        if 'events' in cal_db[cal_id].keys():
            for event_id in cal_db[cal_id]['events']:
                name = cal_db[cal_id]['events'][event_id]['name']
                start = cal_db[cal_id]['events'][event_id]['start']
                end = cal_db[cal_id]['events'][event_id]['end']
                event = [event_id,name,str(start),str(end)]
                returner.append(event)


#### PUT DATA #####

    if data == "newuser":
        if params['password'] == params['password_repeat']:
            success =  back_user.register_user(params['email'],params['password'],params['nickname'])
            if success:
                returner = {
                    "success": True,
                    "data": {
                        "email": params["email"],
                        "nickname": params["nickname"]
                    }
                }
            else: returner = {'success':False}
        else: returner = {'success':False}

    if data == "calendar_new":
        returner = {
            "success": True,
            "data": {
                "id" : 21,
                "name" : params["name"],
                "public" : params["public"]
            }
        }

    if data == "calendar_edit":
        returner = {
            "success": True,
            "data": {
                "id" : params["id"],
                "name" : "Some name",
                "public" : True
            }
        }

    if data == "event_new":
        returner = {
            "success": True,
            "data": {
                "id" : 21,
                "calendar_id": params["calendar_id"],
                "name": params["name"],
                "start": params["start"],
                "end": params["end"]
            }
        }

    if data == "event_edit":
        returner = {
            "success": True,
            "data": {
                "id" : params["id"],
                "calendar_id": 1212,
                "calendars" : getData("calendar_list"),
                "name": "Some name",
                "start": "October 17, 2017 12:00",
                "end": "October 26, 2017 12:00"
            }
        }

    return returner