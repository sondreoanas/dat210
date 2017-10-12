"""
Python backend
For communication with DB and python frontend
Only send valid data to the DB, validate data from frontend
Retrieve required data from DB when needed and send to frontend

Sist oppdatert: 19.09.17 13:22 av Markus
"""
from flask import Flask, g, abort, session
from logged_in_user import *
import mysql.connector
import re
from back_event import *

UPLOAD_FOLDER = "static/images"
ALLOWED_EXTENSIONS = ["png", "jpg", "jpeg", "gif"]

app = Flask(__name__)
app.config["DATABASE_USER"] = "root"
app.config["DATABASE_PASSWORD"] = "root"
app.config["DATABASE_DB"] = "annualcycle"
app.config["DATABASE_HOST"] = "localhost"
app.config["DEBUG"] = True  # only for development!
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.secret_key = "any random string"


the_user = LoggedInUser()


# database connection
def get_db():
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
        return False
    finally:
        cur.close()

def get_password_db(username):
    db = get_db()
    cur = db.cursor()
    try:
        sql = "SELECT Password " \
            "FROM user " \
            "WHERE Email = %s "
        cur.execute(sql, (username,))
        return cur.fetchone()
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()

def set_new_user_db(username, password, name):
    db = get_db()
    cur = db.cursor()
    try:
        sql2 = "INSERT INTO user " \
               "(Email, Password, Name) " \
               "VALUES (%s, %s, %s) "
        cur.execute(sql2, (username, password, name))
        db.commit()
        pass
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()

def get_all_calendars_db(user_id):
    db = get_db() 
    cur = db.cursor()
    try:
        sql = "SELECT Calendarid, Adminlevel " \
            "FROM usercalendars " \
            "WHERE UserId = %s "
        cur.execute(sql, (user_id,))
        return cur.fetchall()
    except mysql.connector.Error as err:
        return False
    finally:
        cur.close()