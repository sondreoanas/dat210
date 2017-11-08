import time



action = {
    "close": {
        "title": "Close",
        "action": "close"
    },
    "confirm": {
        "title": "Confirm",
        "action": "confirm"
    },
    "calendar/new": {
        "title": "Make new calendar",
        "action": "calendar/new"
    }
}
global notif

def notif_append(id):
    pass



#def notif():
#    temp = notif.copy()
#    notif=[]
#    return temp

notifList = []

def append(notif):
    notifList.append(notif)

def flush():
    returner = list(notifList)
    del notifList[:]
    return returner


def notification(id, params={}):

    notifs = {
        0 : n_0,
        1 : n_1,
        2 : n_2,
        3 : n_3,
        4 : n_4,
        5 : n_5,
        6 : n_6,
        7 : n_7,
        8 : n_8,
        9 : n_9
    }
    if id in notifs:
        return notifs[id](params)
    else:
        append(notification(0,{"id": id}))


def n_0(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "Notification error!",
            "body": "Notification error code doesn't exist! Error code:"+str(params["id"]),
            "actions": [action["close"]]

        }
def n_1(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "Login failed!",
            "body": "Something went wrong with your login! Please make sure you typed correct credentials.",
            "actions": [action["close"]]

        }
def n_2(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "Pasword mismatch!",
            "body": "Your passwords did not match.",
            "actions": [action["close"]]

        }
def n_3(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "Register user failed!",
            "body": "Can you guess why?",
            "actions": [action["close"]]

        }
def n_4(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "data",
            "title": "No calendars!",
            "body": "There was no calendars for your user, please create one!",
            "actions": [action["close"], action["calendar/new"]]

        }
def n_5(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "Calendar creation failed!",
            "body": "Something went wrong with creating a new calendar!",
            "actions": [action["close"]]

        }
def n_6(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "Calendar edit failed!",
            "body": "Something went wrong with editing a new calendar!",
            "actions": [action["close"]]

        }
def n_7(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "data",
            "title": "No events!",
            "body": "There was no events in this calendar!",
            "actions": [action["close"]]

        }
def n_8(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "New event failed!",
            "body": "Something went wrong with creating a new event!",
            "actions": [action["close"]]

        }
def n_9(params):
    return {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "Edit event failed!",
            "body": "Something went wrong with editing an event! Error code: "+str(params["id"]),
            "actions": [action["close"]]

        }
