import time

action = {
    "close": {
        "title": "Close",
        "action": "close"
    },
    "confirm": {
        "title": "Confirm",
        "action": "confirm"
    }
}

def notification(id):

    notifs = {
        1 : {
            "id": "notif_" + str(int(round(time.time() * 1000))),
            "type": "form",
            "title": "Login failed!",
            "body": "Something went wrong with your login! Please make sure you typed correct credentials.",
            "actions": [action["close"], action["confirm"]]

        }
    }

    return notifs[id]
