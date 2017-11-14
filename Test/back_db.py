'''
Python backend
For communication with DB and python frontend
Only send valid data to the DB, validate data from frontend
Retrieve required data from DB when needed and send to frontend

Sist oppdatert: 07.11.17 av Markus2
'''
import mf_passwordTester
from flask import g, abort, session
import mysql.connector
from app import app

UPLOAD_FOLDER = "static/images"
ALLOWED_EXTENSIONS = ["png", "jpg", "jpeg", "gif"]


(loadedUsername, loadedPassword) = mf_passwordTester.getUsernamePassword()

app.config["DATABASE_USER"] = loadedUsername
app.config["DATABASE_PASSWORD"] = loadedPassword
app.config["DATABASE_DB"] = "annualcycle"
app.config["DATABASE_HOST"] = "localhost"
app.config["DEBUG"] = True  # only for development!
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.secret_key = "any random string"


def get_db():
    """establishing database connection"""
    if not hasattr(g, "_db"):
        g.db = mysql.connector.connect(host=app.config["DATABASE_HOST"], user=app.config["DATABASE_USER"],
                                       password=app.config["DATABASE_PASSWORD"], database=app.config["DATABASE_DB"])
    return g.db

@app.teardown_appcontext
def teardown_db(error):
    """Closes the database at the end of the request."""
    db = getattr(g, '_db', None)
    if db is not None:
        db.close()

def get_username_db(username):
    db = get_db()
    cur = db.cursor()
    try:
        exist = False
        sql = "SELECT Email " \
            "FROM user " \
            "WHERE Email = %s "
        cur.execute(sql, (username,))
        return cur.fetchone()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def get_user_name_db(username):
    db = get_db()
    cur = db.cursor()
    try:
        exist = False
        sql = "SELECT Name " \
            "FROM user " \
            "WHERE Email = %s "
        cur.execute(sql, (username,))
        return cur.fetchone()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def get_userid_db(username):
    db = get_db()
    cur = db.cursor()
    try:
        exist = False
        sql = "SELECT UserId " \
            "FROM user " \
            "WHERE Email = %s "
        cur.execute(sql, (username,))
        return cur.fetchone()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def get_user_delete_status_db(username):
    db = get_db()
    cur = db.cursor()
    try:
        exist = False
        sql = "SELECT Deleted " \
            "FROM user " \
            "WHERE Email = %s "
        cur.execute(sql, (username,))
        return cur.fetchone()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def get_password_db(username):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "SELECT Password, Salt " \
            "FROM user " \
            "WHERE Email = %s "
        cur.execute(sql, (username,))
        return cur.fetchone()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def set_new_user_db(username, password_hash, salt, name):
    db = get_db()
    cur = db.cursor()
    try:
        sql2 = "INSERT INTO user " \
               "(Email, Password, Salt, Name) " \
               "VALUES (%s, %s, %s, %s) "
        cur.execute(sql2, (username, password_hash, salt, name))
        db.commit()
        print("successfull creation")
        return cur.lastrowid
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def edit_user_db(user_id, username_old, username_new, password_hash, salt, name):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "UPDATE user " \
            "SET Username = %s, Name = %s, Password = %s, Salt = %s " \
            "WHERE Username = %s AND UserId = %s "
        cur.execute(sql, (username_new, name, password_hash, salt, username_old, user_id))
        db.commit()
        return cur.lastrowid
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def get_all_calendars_db(user_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT U.CalendarId, C.Name, U.Adminlevel, C.Public " \
            "FROM usercalendars U, calendar C " \
            "WHERE U.UserId = %s AND C.CalendarId = U.CalendarId "
        cur.execute(sql, (user_id,))
        return cur.fetchall()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def get_calendar_db(user_id, calendar_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT CalendarId, Name, Public " \
            "FROM calendar " \
            "WHERE CalendarId = " \
            "(SELECT CalendarId " \
            "FROM usercalendars " \
            "WHERE CalendarId = %s AND UserId = %s) "
        cur.execute(sql, (calendar_id, user_id))
        return cur.fetchone()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def get_all_calendar_events_db(user_id, calendar_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT EventId, CalendarId " \
            "FROM eventcalendar " \
            "WHERE CalendarId = %s AND Deleted = 0 "
        cur.execute(sql, (calendar_id,))
        return cur.fetchall()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def get_event_db(user_id, event_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT EventId, Name, Description, Start, End " \
            "FROM eventn " \
            "WHERE EventId = %s "
        cur.execute(sql, (event_id,))
        return cur.fetchone()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def add_new_calendar_db(calendar_name, public_bool):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "INSERT INTO calendar " \
            "(Name, Public) " \
            "VALUES (%s, %s) "
        cur.execute(sql, (calendar_name, public_bool))
        calendar_id = cur.lastrowid
        db.commit()
        return calendar_id
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def edit_calendar_db(user_id, calendar_id, calendar_name, public_bool):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "UPDATE calendar " \
            "SET Name = %s, Public = %s " \
            "WHERE CalendarId = %s AND CalendarId = (SELECT CalendarId " \
            "FROM usercalendars " \
            "WHERE CalendarId = %s AND UserId = %s AND Adminlevel >= 2) "
        cur.execute(sql, (calendar_name, public_bool, calendar_id, calendar_id, user_id))
        db.commit()
        return True
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def add_new_usercalendar_db(user_id, calendar_id):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "INSERT INTO usercalendars " \
            "(UserId, CalendarId, Adminlevel, Notifications) " \
            "VALUES (%s, %s, %s, %s) "
        cur.execute(sql, (user_id, calendar_id, 3, 0))
        db.commit()
        return True
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def add_new_event_db(name, start_time, end_time):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "INSERT INTO eventn " \
               "(Name, Start, End) " \
               "VALUES (%s, %s, %s) "
        cur.execute(sql, (name, start_time, end_time))
        db.commit()
        return cur.lastrowid
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def edit_event_db(user_id, old_calendar_id, new_calendar_id, event_id, event_name, event_description, event_start, event_end, event_interval, event_terminatedate):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "UPDATE eventn " \
            "SET Name = %s, Description = %s, Start = %s, End = %s, `Interval` = %s, Terminatedate = %s " \
            "WHERE EventId = %s AND EventId = (SELECT EventId " \
            "FROM eventcalendar " \
            "WHERE EventId = %s AND CalendarId = (SELECT CalendarId " \
            "FROM usercalendars " \
            "WHERE CalendarId = %s AND UserId = %s AND Adminlevel >= 2)) "
        cur.execute(sql, (event_name, event_description, event_start, event_end, event_interval, event_terminatedate, event_id, event_id, calendar_id, user_id))
        db.commit()
        return True
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def delete_event_db(event_id):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "UPDATE eventn " \
            "SET Deleted = 1 " \
            "WHERE EventId = %s "
        cur.execute(sql, (event_id,))
        db.commit()
        return True
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def add_new_eventcalendar_db(event_id, calendar_id):
    db = get_db()
    cur = db.cursor()
    try:
        sql2 = "INSERT INTO eventcalendar " \
               "(EventId, CalendarId) " \
               "VALUES (%s, %s) "
        cur.execute(sql2, (event_id, calendar_id))
        db.commit()
        return True
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def add_new_task_db(name, description, start_date, timestamp, calendar_id):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "INSERT INTO task " \
               "(Name, Description, Startdate, Timestamp, CalendarId) " \
               "VALUES (%s, %s, %s, %s, %s) "
        cur.execute(sql, (name, description, start_date, timestamp, calendar_id))
        task_id = cur.lastrowid
        db.commit()
        return task_id
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def add_new_usertask_db(task_id, user_id):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "INSERT INTO usertask " \
               "(UserId, TaskId) " \
               "VALUES (%s, %s) "
        cur.execute(sql, (user_id, task_id))
        db.commit()
        return True
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def add_new_eventtask_db(task_id, event_id):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "INSERT INTO eventtask " \
               "(EventId, TaskId) " \
               "VALUES (%s, %s) "
        cur.execute(sql, (event_id, task_id))
        db.commit()
        return True
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()

def add_new_child_task_db(name, description, start_date, timestamp, calendar_id, parent_id):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "INSERT INTO task " \
               "(Name, Description, Startdate, Timestamp, CalendarId, ParentId) " \
               "VALUES (%s, %s, %s, %s, %s, %s) "
        cur.execute(sql, (name, description, start_date, timestamp, calendar_id, parent_id))
        db.commit()
        return True
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()

def add_new_task_calendar_db(task_id, calendar_id):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "INSERT INTO calendartask " \
               "(CalendarId, TaskId) " \
               "VALUES (%s,%s) "
        cur.execute(sql, (calendar_id, task_id))
        db.commit()
        return True
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()

def get_all_usertasks_db(user_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT TaskId, Name, task.Interval, Deleted, IsDone, ParentId, CalendarId, Timestamp " \
            "FROM usertask " \
            "WHERE UserId = %s AND Deleted = 0 "
        cur.execute(sql, (user_id,))
        return cur.fetchall()
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()

def get_task_db(task_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT Name, Description, Startdate, Interval " \
            "FROM task " \
            "WHERE TaskId = %s AND Deleted = 0 "
        cur.execute(sql, (task_id,))
        return cur.fetchall()
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()

def get_all_calendartask_db(calendar_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT TaskId, Name, task.Interval, Deleted, IsDone, ParentId, CalendarId, Timestamp " \
            "FROM task " \
            "WHERE CalendarId = %s AND Deleted = 0 "
        cur.execute(sql, (calendar_id,))
        return cur.fetchall()
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()

def get_child_task_db(task_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT TaskId, Name, task.Interval, Deleted, IsDone, ParentId, CalendarId, Timestamp " \
            "FROM task " \
            "WHERE ParentId = %s AND Deleted = 0 "
        cur.execute(sql, (calendar_id,))
        return cur.fecthone()
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()

def get_events_usercalendar_interval(user_id, calendar_id, interval_start, interval_end):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT E.Name, E.EventId, E.Start, E.End " \
            "FROM eventn E, eventcalendar C " \
            "WHERE " \
            "CalendarId = (SELECT CalendarId FROM usercalendars WHERE UserId = %s AND CalendarId = %s) " \
            "AND E.EventId = C.EventId " \
            "AND E.Start BETWEEN %s AND %s AND E.End BETWEEN %s AND %s "

        cur.execute(sql, (user_id, calendar_id, interval_start, interval_end, interval_start, interval_end))
        return cur.fetchall()
    except mysql.connector.Error as err:
        print(err)
        return False
    finally:
        cur.close()
