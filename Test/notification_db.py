import pymysql

connection = pymysql.connect(host='localhost',
                             user='root',
                             password='Stavanger1996', # enter you db password
                             db='annualcycle',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)


def get_notification_details():
    cur = connection.cursor()
    details = []
    try:
        sql = """SELECT c.Name Calendarname, us.Email, e.Name Eventname, e.Start, usc.Notificationalerttime, usc.CalendarId, e.EventId
            FROM usercalendars usc, annualcycle.user us, calendar c, eventcalendar ec, eventn e
            WHERE usc.Notifications = 1 and ec.EventId = e.EventId and e.Start >= NOW() and ec.Notificationsent=0 and usc.deleted=0 and us.deleted=0 and c.deleted=0 and ec.deleted=0 and e.deleted=0 and usc.Userdeleted=0;"""
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
        return True
