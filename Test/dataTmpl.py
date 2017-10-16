def getData(data, id):
    returner = {}

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
        returner = [
            [21, "Calendar 01",True],
            [5454, "Calendar 02",False],
            [554, "Calendar 03",True],
            [4545, "Calendar 04",False]
        ]

    if data == "calendar_edit":
        returner = {
            "id" : id,
            "name" : "Calendar 01",
            "public" : True
        }


    if data == "event_list":
        returner = [
            [4545, "Event 01","October 17, 2017 12:00","October 26, 2017 12:00"],
            [45, "Event 02","October 17, 2017 12:00","October 26, 2017 12:00"],
            [54, "Event 03","October 17, 2017 12:00","October 26, 2017 12:00"],
            [454, "Event 04","October 17, 2017 12:00","October 26, 2017 12:00"]
        ]


    if data == "event_edit":
        returner = {
            "id" : id,
            "calendars" : [[False, "Calendar 01", 21, True],[False, "Calendar 02", 54, False],[True, "Calendar 03", 841, True],[False, "Calendar 04", 544, False] ],
            "name" : "Event 01",
            "start" : "Tue Oct 17 2017 12:00:00 GMT+0200 (W. Europe Daylight Time)",
            "end" : "Thu Oct 26 2017 12:00:00 GMT+0200 (W. Europe Daylight Time)"
        }

    return returner
