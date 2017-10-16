def notif(condition, truemessage, falsemessage, trueaction, falseaction):
    if condition:
        return {
            "message": truemessage,
            "action": trueaction,
            "time": "2017/10/09 21:51"
        }
    else:
        return {
            "message": falsemessage,
            "action": falseaction,
            "time": "2017/10/09 21:51"
        }
