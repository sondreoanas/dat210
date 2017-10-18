import back_user
import config as c
from logged_in_user import LoggedInUser
import time



def getData(data, params=None,):
    returner = {}

    if data == "login":
        success = back_user.login(params['username'],params['password'])
        if success:
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
        calendars = []
        for cal_id in cal_db:
            calendar = []
            calendar.append(cal_id.value())
            calendar.append(cal_id['calendar_name'])
            calendar.append(cal_id['calendar_rights'])
            calendars.append(calendar)

        return calendars

    if data == "event_list":
        #returner = [
        #    [4545, "Event 01","October 17, 2017 12:00","October 26, 2017 12:00"],
        #    [45, "Event 02","October 17, 2017 12:00","October 26, 2017 12:00"],
        #    [54, "Event 03","October 17, 2017 12:00","October 26, 2017 12:00"],
        #     [454, "Event 04","October 17, 2017 12:00","October 26, 2017 12:00"]
        #]

        cal_db = c.the_user.get_user_calendars()
        events = []
        if cal_db:
        cal_id = 1
        #for cal_id in cal_db:
        if 'events' in cal_db[cal_id].keys():
           returner = {'events':[]}
           for event_id in cal_db[cal_id]['events']:
              start = cal_db[cal_id]['events'][event_id]['start']
              end = cal_db[cal_id]['events'][event_id]['end']
              
              event = {
                'start' : time.mktime(start)
                'end' : time.mktime(end)
                'name' : cal_db[cal_id]['events'][event_id]['name']
                  
              }
              returnerer['events'].append(event)


#### PUT DATA #####

    if data == "newuser":
        returner = {
            "success": True,
            "data": {
                "email": params["email"],
                "nickname": params["nickname"]
            }
        }

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
