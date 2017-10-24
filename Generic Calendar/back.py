"""
Python backend
For communication with DB and python frontend
Only send valid data to the DB, validate data from frontend
Retrieve required data from DB when needed and send to frontend

Sist oppdatert: 19.09.17 13:22 av Markus
"""


from flask import Flask, render_template, g, request, redirect, url_for, flash, abort, session, send_from_directory, current_app
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
import json
import os
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = "static/images"
ALLOWED_EXTENSIONS = ["png", "jpg", "jpeg", "gif"]

app = Flask(__name__)
app.config["DATABASE_USER"] = "root"
app.config["DATABASE_PASSWORD"] = "root"
app.config["DATABASE_DB"] = "annualcycle_v0.1.0"
app.config["DATABASE_HOST"] = "localhost"
app.config["DEBUG"] = True  # only for development!
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.secret_key = "any random string"


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


def existing_user(username):
    db = get_db()
    cur = db.cursor()
    user_exist = False
    sql = "SELECT Email " \
           "FROM user " \
           "WHERE Email = %s "

    cur.execute(sql, (username,))
    if cur.fetchall():
        user_exist = True
    return user_exist


def valid_login(username, password):
    """Checks if username-password combination is valid."""
    db = get_db()
    cur = db.cursor()
    user_exist = False
    sql = "SELECT Password " \
          "FROM user " \
          "WHERE Email = %s "

    cur.execute(sql, (username,))

    for (pw,) in cur:
        user_exist = True
        user_password = pw
    cur.close()

    """
    Use this when the raw password is not stored in the database

    if user_exist:
        return check_password_hash(user_password, password)
    return user_exist
    """

    if user_exist:
        return password == user_password
    return user_exist


def valid_register_user(username, password, name):
    db = get_db()
    cur = db.cursor()
    success = False
    if existing_user(username):
        success = False

    sql2 = "INSERT INTO products " \
           "(Email, Password, Name) " \
           "VALUES (%s, %s, %s) "
    cur.execute(sql2, (username, password, name))
    if existing_user(username):
        success = True
    return success
