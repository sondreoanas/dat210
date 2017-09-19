"""
Python backend
For communication with DB and python frontend
Only send valid data to the DB, validate data from frontend
Retrieve required data from DB when needed and send to frontend
"""

from flask import Flask, render_template, g, request, redirect, url_for, flash, abort, session, send_from_directory
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
app.config["DATABASE_DB"] = "a9"
app.config["DATABASE_HOST"] = "localhost"
app.config["DEBUG"] = True  # only for development!
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.secret_key = "any random string"
