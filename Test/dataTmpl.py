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
                        "My Event" : [0,"event/list"]
                    }]
                }
            }

    if data == "calendar_list":
        returner = {
            "Calendar 01" : [21,"public","ect"],
            "Calendar 02" : [5454,"public","ect"],
            "Calendar 03" : [554,"public","ect"],
            "Calendar 04" : [545,"public","ect"]
        }

    if data == "main_calendar_edit":
        returner = {
            "id" : id,
            "name" : "Calendar 01",
            "public" : True,
            "etc" : "blabla"
        }

    return returner
