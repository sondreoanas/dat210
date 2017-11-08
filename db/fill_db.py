"""
Python script for filling db with dummy data
Last updated: Vebjørn A.A 17.10.17
"""


import pymysql
import random
from random import randint
import names
from werkzeug.security import generate_password_hash
import datetime
import calendar
import tempfile

connection = pymysql.connect(host='localhost',
                             user='root',
                             password='psw',
                             db='annualcycle',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

password = "Password123"  # Used as password for users
salt = "salt"  # Used as salt for users

def make_email(name):
    email = ""
    names = name.split(" ")
    for name in names:
        if name == names[0]:
            email = name.lower()
        elif name == names[len(names)-1]:
            email = email + "@" + name.lower() + ".no"
        else:
            email = email + "." + name.lower()
    return email


def getDate(m, y, start=1):
    # For months having 30 days
    if m in [4,6,9,11]:
        if start == 30:
            return random.randrange(start,31,1)
        return random.randrange(start,30,1)
    # For month of Feb, to check if year is leap or not
    elif m == 2:
        if not calendar.isleap(y):
            if start == 28:
                return random.randrange(start,29,1)
            return random.randrange(start,28,1)
        else:
            if start == 29:
                return random.randrange(start,30,1)
            return random.randrange(start,29,1)
    else:
        if start == 31:
            return random.randrange(start,32,1)
        return random.randrange(start,31,1)

def getRandomPeriod(minYear, maxYear):
    period = []
    if minYear > maxYear:
        raise ValueError('Please enter proper year range')
    if minYear == maxYear:
        y1 = minYear
        y2 = minYear
    else:
        y1 = random.randrange(minYear, maxYear)
        # Choosing lower bound y2 to be same as y1, so that y2 >= y1
        y2 = random.randrange(y1, maxYear)

    m1 = random.randrange(1,12)
    if y2 != y1:
        m2 = random.randrange(1,12,1)
    else:
        # Choosing lower bound m2 to be same as m1, so that m2 >= m1
        m2 = random.randrange(m1,12,1)

    d1 = getDate(m1, y1)
    if m1==m2 and y1==y2:
        d2 = getDate(m2, y2, start=d1+1)
    else:
        d2 = getDate(m2, y2)

    t1 = datetime.datetime(y1,m1,d1)
    t2 = datetime.datetime(y2,m2,d2)
    period.append(t1)
    period.append(t2)
    return period

def generate_calenders(n):
    for x in range(n):
        cur = connection.cursor()
        try:
            calendarname = "Calendar #" + str(x)
            sql = "INSERT INTO calendar (Name, Public) VALUES (%s, %s)"
            cur.execute(sql, (calendarname, random.getrandbits(1)))
            connection.commit()
        finally:
            cur.close()
    print("Added " + str(n) + " calendars to db")


def generate_users(n):
    for x in range(n):
        cur = connection.cursor()
        if n == 1:
            try:
                name = "Ola Nordmann"
                sql = "INSERT INTO User (Email, Password, Salt, Name) VALUES (%s, %s, %s, %s)"
                cur.execute(sql, (make_email(name), generate_password_hash(password), salt, name))
                connection.commit()
            finally:
                cur.close()
        else:
            try:
                name = names.get_full_name()
                sql = "INSERT INTO User (Email, Password, Salt, Name) VALUES (%s, %s, %s, %s)"
                cur.execute(sql, (make_email(name), generate_password_hash(password), salt, name))
                connection.commit()
            finally:
                cur.close()
    print("Added " + str(n) + " users to db")


def generate_usercalendars():
    users = []
    calenders = []
    cur = connection.cursor()
    try:
        sql = "SELECT UserId from User"
        cur.execute(sql)
        for(UserId) in cur:
            users.append(UserId)
        connection.commit()
        sql = "SELECT CalendarId from Calendar"
        cur.execute(sql)
        for(CalendarId) in cur:
            calenders.append(CalendarId)
        connection.commit()
    finally:
        cur.close()

    for i in range(abs(len(users)-len(calenders))*2 + 10):
        cur = connection.cursor()
        try:
            userId = random.choice(users).get("UserId")
            calendarId = random.choice(calenders).get("CalendarId")
            usercal = []
            sql = "SELECT UserId, CalendarId FROM Usercalendars WHERE UserId=%s and CalendarId=%s"
            cur.execute(sql, (userId,calendarId ))
            for(userId, calendarId) in cur:
                usercal.append({
                "userId": userId,
                "calendarId": calendarId
            })
            if not usercal:
                sql = "INSERT INTO Usercalendars (UserId, CalendarId, Adminlevel, Notifications) VALUES (%s, %s, %s, %s)"
                cur.execute(sql, (userId, calendarId, randint(0, 3),random.getrandbits(1)))
                connection.commit()
            else:
                continue
        finally:
            cur.close()
    print("Attached users to calendars")


def generate_events(n):
    for x in range(n):
        cur = connection.cursor()
        try:
            eventname = "event #" + str(x)
            now = datetime.datetime.now()
            year = random.randint(now.year, now.year+2)
            period = getRandomPeriod(year, year)
            sql = "INSERT INTO Eventn (Name, Start, End) VALUES (%s, %s, %s)"
            cur.execute(sql, (eventname, period[0], period[1]))
            connection.commit()
        finally:
            cur.close()
    print("Added " + str(n) + " events to db")


def generate_eventcalendars():
    events = []
    calenders = []
    cur = connection.cursor()
    try:
        sql = "SELECT EventId from Eventn"
        cur.execute(sql)
        for(UserId) in cur:
            events.append(UserId)
        connection.commit()
        sql = "SELECT CalendarId from Calendar"
        cur.execute(sql)
        for(CalendarId) in cur:
            calenders.append(CalendarId)
        connection.commit()
    finally:
        cur.close()

    for i in range(len(events)+len(calenders)):
        cur = connection.cursor()
        try:
            eventid = random.choice(events).get("EventId")
            calendarId = random.choice(calenders).get("CalendarId")

            eventcal = []
            sql = "SELECT EventId, CalendarId FROM EventCalendar WHERE EventId=%s and CalendarId=%s"
            cur.execute(sql, (eventid, calendarId))
            for(userId, calendarId) in cur:
                eventcal.append({
                "userId": userId,
                "calendarId": calendarId
            })
            if not eventcal:
                sql = "INSERT INTO EventCalendar (EventId, CalendarId) VALUES (%s, %s)"
                cur.execute(sql, (eventid, calendarId))
                connection.commit()
            else:
                continue
        finally:
            cur.close()
    print("Attached events to calendars")


def generate_tasks(n):
    calenders = []
    cur = connection.cursor()
    try:
        sql = "SELECT CalendarId from Calendar"
        cur.execute(sql)
        for(CalendarId) in cur:
            calenders.append(CalendarId)
        connection.commit()
    finally:
        cur.close()

    for x in range(n):
        cur = connection.cursor()
        try:
            taskaname = "task #" + str(x)
            startdate = datetime.datetime.now()
            calendarId = random.choice(calenders).get("CalendarId")
            interval = " "

            sql = "INSERT INTO task (Name, Startdate, `Interval`, CalendarId) VALUES (%s, %s, %s, %s)"
            cur.execute(sql, (taskaname, startdate, interval, calendarId))
            connection.commit()
        finally:
            cur.close()
    print("Added " + str(n) + " tasks to db")



def generate_eventtask():
    events = []
    tasks = []
    cur = connection.cursor()
    try:
        sql = "SELECT EventId from Eventn"
        cur.execute(sql)
        for(UserId) in cur:
            events.append(UserId)
        connection.commit()
        sql = "SELECT TaskId from Task"
        cur.execute(sql)
        for(TaskId) in cur:
            tasks.append(TaskId)
        connection.commit()
    finally:
        cur.close()

    for i in range(int(len(events)/2)):
        cur = connection.cursor()
        try:
            eventid = random.choice(events).get("EventId")
            taskId = random.choice(tasks).get("TaskId")

            eventtask = []
            sql = "SELECT EventId, TaskId FROM Eventtask WHERE EventId=%s and TaskId=%s"
            cur.execute(sql, (eventid, taskId))
            for(userId, calendarId) in cur:
                eventtask.append({
                "userId": userId,
                "taskId": taskId
            })
            if not eventtask:
                sql = "INSERT INTO Eventtask (EventId, TaskId) VALUES (%s, %s)"
                cur.execute(sql, (eventid, taskId))
                connection.commit()
            else:
                continue
        finally:
            cur.close()
    print("Attached some tasks to event")



def generate_files(n):
    for x in range(n):
        cur = connection.cursor()
        path = "\data"
        try:
            tf = tempfile.NamedTemporaryFile()
            tempname = tf.name
            filename = tempname.split("\\")
            sql = "INSERT INTO Files (Filename, Path) VALUES (%s, %s)"
            cur.execute(sql, (filename[len(filename)-1], path))
            connection.commit()
        finally:
            cur.close()
    print("Added " + str(n) + " files to db")


def generate_eventfiles():
    events = []
    files = []
    cur = connection.cursor()
    try:
        sql = "SELECT EventId from Eventn"
        cur.execute(sql)
        for(EventId) in cur:
            events.append(EventId)
        connection.commit()
        sql = "SELECT FileId from Files"
        cur.execute(sql)
        for(FileId) in cur:
            files.append(FileId)
        connection.commit()
    finally:
        cur.close()

    for i in range(len(files)):
        cur = connection.cursor()
        try:
            eventid = random.choice(events).get("EventId")
            fileid = random.choice(files).get("FileId")

            eventfiles = []
            sql = "SELECT EventId, FileId FROM EventFiles WHERE EventId=%s and FileId=%s"
            cur.execute(sql, (eventid, fileid))
            for(eventid, fileid) in cur:
                eventfiles.append({
                "eventid": eventid,
                "fileid": fileid
            })
            if not eventfiles:
                sql = "INSERT INTO  EventFiles(EventId, FileId) VALUES (%s, %s)"
                cur.execute(sql, (eventid, fileid))
                connection.commit()
            else:
                continue
        finally:
            cur.close()
    print("Attached files to an event")


def fill_db(nc, nu, ne, te, nf):  # nc = #calenders, nu = #users, ne = #events, te = #tasks, nf = #files
    generate_calenders(nc)
    generate_users(nu)
    generate_usercalendars()
    generate_events(ne)
    generate_eventcalendars()
    generate_tasks(te)
    generate_eventtask()
    generate_files(nf)
    generate_eventfiles()


def main():
    fill_db(1,1,10,4,1)
    connection.close()


if __name__ == "__main__":
    main()

