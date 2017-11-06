import mf_passwordTester
import pymysql

(loadedUsername, loadedPassword) = mf_passwordTester.getUsernamePassword()

connection = pymysql.connect(host='localhost',
                             user=loadedUsername,
                             password=loadedPassword, # enter you db password
                             db='annualcycle',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)


def get_notification_details():
    cur = connection.cursor()
    details = []
    try:
        sql = """SELECT c.Name Calendarname, us.Email, e.Name Eventname, e.Start, usc.Notificationalerttime, usc.CalendarId, e.EventId
                from calendar c, annualcycle.user us, eventn e, eventcalendar ec, usercalendars usc
                where ec.EventId = e.EventId and ec.CalendarId = c.CalendarId and usc.CalendarId = ec.CalendarId and usc.Notifications = 1 and e.Start >= NOW()
                and ec.Notificationsent=0 and usc.deleted=0 and us.deleted=0 and c.deleted=0 and ec.deleted=0 and e.deleted=0 and usc.Userdeleted=0;"""
        cur.execute(sql)
        for arg in cur:
            temp = []
            for val in arg.items():
                temp.append({
                    val[0]: val[1],
                })
            details.append(temp)
    except pymysql.MySQLError as err:
        return []
    finally:
        cur.close()
        return details


def set_notification_sent(EventId, CalendarId):
    cur = connection.cursor()
    try:
        sql = "UPDATE eventcalendar SET Notificationsent = 1 WHERE EventId = %s and CalendarId = %s"
        cur.execute(sql, (EventId, CalendarId))
        connection.commit()
    except pymysql.MySQLError as err:
        return False
    finally:
        cur.close()
        return True
