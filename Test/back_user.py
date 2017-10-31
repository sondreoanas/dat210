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
    """takes in the username on successful login and initializes a logged in user"""
    if user_exist(username):
        c.the_user.set_username(username)
        c.the_user.set_name(db.get_user_name_db(username)[0])
        c.the_user.set_userid(db.get_userid_db(username)[0])
        #session["the_user"] = c.the_user.contents()


# check for valid username function
def valid_username(username):
    """returns the dict:
    \"success\": bool,
    \"error\": error message
    """

    match = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', username)
    if user_exist(username):
        return {"success": False, "error": "Username already in use"}
    if match is None:
        return {"success": False, "error": "Not a valid email address"}
    return {"success": True}


# function to check if a user exists
def user_exist(username):
    """returns the dict
    \"success\": bool
    """

    user = db.get_user_delete_status_db(username)
    if user and user[0] == 0:
        return {"success": True}
    return {"success": False}


# check for valid password
def valid_password(password):
    """returns the dict:
    \"success\": bool,
    \"error\": error message
    """
    #if re.search(r'[A-Za-z0-9@#$%^&+=]{8,}', password):
    #match = re.search('(?=[A-Z]+)(?=[0-9]+)(?=[\s!#@£$%]+){8,}.*$', password)
    #match = re.match('(?=[a-z])', password)
    #if match is None:
    #    return False

    return [True]

    if len(password) < 8:
        return {"success": False,
                "error": "Password needs to contain at least 8 characters"}
    elif re.search('[a-z]', password) is None:
        return {"success": False,
                "error": "Password needs to contain at least one lowercase letter"}
    elif re.search('[0-9]', password) is None:
        return {"success": False,
                "error": "Password needs to contain at least one number"}
    elif re.search('[A-Z]', password) is None:
        return {"success": False,
                "error": "Password needs to contain at least one uppercase letter"}
    elif re.search('[\s!#@£$%]', password) is None:
        return {"success": False,
                "error": "Password needs to contain at least one space or one of these: ! # @ £ $ % "}
    elif re.search('123', password):
        return {"success": False,
                "error": "You cannot use 123 in your password"}
    else:
        return {"success": True}


# login function
def login(username, password):
    """returns the dict:
    \"success\": bool,
    \"user_id\": user_id
    """

    if user_exist(username):
        user_password = db.get_password_db(username)
        if user_password:
            login_success = sec.check_password(password, user_password[0], user_password[1])
            if login_success:
                init_logged_in_user(username)
                return {"success": True, "user_id": db.get_userid_db(username)[0]}
    return {"success": False}


# logout function
def logout():
    """clears session and returns True"""
    session.clear()
    return True


# register user function
def register_user(username, password, name):
    """returns the dict:
    \"success\": success bool
    \"username\": username
    """

    validate_username = valid_username(username)
    validate_password = valid_password(password)
    if not validate_username[0]:
        return {"success": False}
    elif not validate_password[0]:
        return {"success": False}
    if not user_exist(username):
        password_hashed = sec.create_password(password)
        user_id = db.set_new_user_db(username, password_hashed[0], password_hashed[1], name)
        if user_exist(username):
            cal_name = name + "\'s calendar"
            cal_id = db.add_new_calendar_db(cal_name, 0)
            db.add_new_usercalendar_db(user_id, cal_id)
            return {"success": True, "username": username}
    return {"success": False}


def edit_user(user_id, username_old, username_new, password, name):
    """if password has not been edited please send in the string \"use old password\"
    if successfull return dict:

    \"success\": True, \"user_id\": user_id
    if unsuccessfull returns dict:
    \"success\": False, \"error\": error message
    """

    if password != "use old password":
        validate_password = valid_password(password)
        if not validate_password["success"]:
            return [False, validate_password["error"]]
        password_hashed = sec.create_password(password)
    return {
        "success": True,
        "user_id": db.edit_user_db(user_id, username_old, username_new, password_hashed[0], password_hashed[1], name)
    }
