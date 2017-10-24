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


def init_logged_in_user(username):
    if user_exist(username):
        c.the_user.set_username(username)
        c.the_user.set_name(db.get_user_name_db(username)[0])
        c.the_user.set_userid(db.get_userid_db(username)[0])
        #back_event.init_all_calendars()
        #back_event.init_all_userevents()


# check for valid username function
def valid_username(username):
    match = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', username)
    if user_exist(username):
        return False
    if match is None:
        return False
    return True


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
        return True


# login function
def login(username, password):
    if user_exist(username):
        init_logged_in_user(username)
        user_password = db.get_password_db(username)
        if user_password:
            return sec.check_password(password, user_password[0], user_password[1])
    return False


# logout function
def logout():
    c.the_user.clear()
    pass


# register user function
def register_user(username, password, name):
    #if not valid_username(username) or not valid_password(password):
    #    return False
    if not user_exist(username):
        password_hashed = sec.create_password(password)
        db.set_new_user_db(username, password_hashed[0], password_hashed[1], name)
        if user_exist(username):
            return username
    return False


def edit_user(username_old, username_new, password, name):
    if not valid_password(password):
        return False
    password_hashed = sec.create_password(password)
    return db.edit_user_db(username_old, username_new, password_hashed[0], password_hashed[1], name)
