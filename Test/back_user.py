"""
Python backend
For communication with DB and python frontend
Only send valid data to the DB, validate data from frontend
Retrieve required data from DB when needed and send to frontend

Sist oppdatert: 19.09.17 13:22 av Markus
"""

from flask import Flask, g, abort, session
import mysql.connector
import re
import back_event
import back_db as db
import config as c
import security as sec
import logged_in_user as liu


def init_logged_in_user(username):
    if user_exist(username):
        c.the_user.set_username(username)
        c.the_user.set_name(db.get_user_name_db(username)[0])
        c.the_user.set_userid(db.get_userid_db(username)[0])
        #session["the_user"] = c.the_user.contents()


# check for valid username function
def valid_username(username):
    match = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', username)
    if user_exist(username):
        return [False, "Username already in use"]
    if match is None:
        return [False, "Not a valid email address"]
    return [True]


# function to check if a user exists
def user_exist(username):
    user = db.get_user_delete_status_db(username)
    if user and user[0] == 0:
        return True
    return False


# check for valid password
def valid_password(password):
    #if re.search(r'[A-Za-z0-9@#$%^&+=]{8,}', password):
    #match = re.search('(?=[A-Z]+)(?=[0-9]+)(?=[\s!#@£$%]+){8,}.*$', password)
    #match = re.match('(?=[a-z])', password)
    #if match is None:
    #    return False

    return [True]

    if len(password) < 8:
        return False
    elif re.search('[0-9]', password) is None:
        return False
    elif re.search('[A-Z]', password) is None:
        return False
    elif re.search('[a-z]', password) is None:
        return False
    elif re.search('[\s!#@£$%]', password) is None:
        return False
    elif re.search('123', password):
        return False
    else:
        return [True]


# login function
def login(username, password):
    if user_exist(username):
        init_logged_in_user(username)
        user_password = db.get_password_db(username)
        if user_password:
            login_success = sec.check_password(password, user_password[0], user_password[1])
            if login_success:
                return db.get_userid_db(username)[0]
    return False


# logout function
def logout():
    session.clear()
    return True


# register user function
def register_user(username, password, name):
    validate_username = valid_username(username)
    validate_password = valid_password(password)
    if not validate_username[0]:
        return [False]
    elif not validate_password[0]:
        return [False]
    if not user_exist(username):
        password_hashed = sec.create_password(password)
        user_id = db.set_new_user_db(username, password_hashed[0], password_hashed[1], name)
        if user_exist(username):
            cal_name = name + "\'s calendar"
            cal_id = db.add_new_calendar_db(cal_name, 0)
            db.add_new_usercalendar_db(user_id, cal_id)
            return [True, username]
    return [False]


def edit_user(username_old, username_new, password, name):
    if not valid_password(password):
        return False
    password_hashed = sec.create_password(password)
    return db.edit_user_db(username_old, username_new, password_hashed[0], password_hashed[1], name)
