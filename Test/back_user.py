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
from back_db import *
import config as c


def init_logged_in_user(username):
    if user_exist(username):
        c.the_user.set_username(username)
        c.the_user.set_name(get_user_name_db(username)[0])
        c.the_user.set_userid(get_userid_db(username)[0])
        init_all_calendars()
        init_all_userevents()


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
    user = get_user_delete_status_db(username)
    if user and user[0] == 0:
        return True
    return False


# check for valid password
def valid_password(username, password):
    user_password = get_password_db(username)
    if user_password:
        return password == user_password[0]
    return False


# login function
def login(username, password):
    if user_exist(username):
        init_logged_in_user(username)
        return valid_password(username, password)
    return False


# logout function
def logout():
    c.the_user.clear()
    pass


# register user function
def register_user(username, password, name):
    if not valid_username(username):
        return False
    if not user_exist(username):
        set_new_user_db(username, password, name)
        if user_exist(username):
            return username
    return False
