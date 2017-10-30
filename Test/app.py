"""
    Flask
    this file is the core of the Calendar
    Sist oppdatert: Nils 30.10.2017
"""
import dataIO as io
import json
import config as c
import back_user
from flask import Flask, request, redirect, url_for, render_template, flash, session

app = Flask(__name__)
app.secret_key = "any random string"


@app.route("/loadViewEvents", methods=["POST"])
def loadViewEvents():
    params = {
        "load_start": request.form.get('start', 0),
        "load_end": request.form.get('end', 0)
    }
    return json.dumps(io.getData("loadview",params))

@app.route("/getHTML")
def getHTML():
    html = request.args.get("html", None)
    with open('html/' + html +'.html', 'r') as f:
        template = f.read()
    data = {
        "template" : template,
        "data" : {}
    }
    return json.dumps(data)


@app.route("/getTMPL")
def getTMPL():
    tmpl = request.args.get("tmpl", None)
    data = request.args.get("data", None)
    params = {
        "id": request.args.get("id", None),
        "args": request.args
    }
    with open('tmpl/' + tmpl +'.tmpl', 'r') as f:
        template = f.read()
    jstring = {
        "template" : template,
        "data": io.getData(data, params)
    }
    return json.dumps(jstring)

  
@app.route("/login_form", methods=["POST"])
def login():
    params = {
        "username": request.form.get('username', 0),
        "password": request.form.get('password', 0)
    }
    return json.dumps(io.getData("login", params))


@app.route("/forgotpass_form", methods=["POST"])
def forgotpass():
    params = {
        "username": request.form.get('form_userid', 0)
    }
    return json.dumps(io.getData("forgotpass", params))


@app.route("/newuser_form", methods=["POST"])
def newuser():
    params = {
        "email": request.form.get('form_new_email', 0),
        "nickname": request.form.get('form_new_nick', 0),
        "password": request.form.get('form_new_pass', 0),
        "password_repeat": request.form.get('form_new_pass_repeat', 0)
    }
    return json.dumps(io.getData("newuser", params))


@app.route("/calendar/new_form", methods=["POST"])
def calendar_new_form():
    params = {
        "name": request.form.get('form_calendar_name', 0),
        "public": request.form.get('form_calendar_public', 0)
    }
    print(params)
    return json.dumps(io.getData("calendar_new", params))


@app.route("/calendar/edit/edit_form", methods=["POST"])
def calendar_edit_form():
    params = {
        "id": request.form.get('form_calendar_id', 0),
        "name": request.form.get('form_calendar_name', 0),
        "public": request.form.get('form_calendar_public', 0)
    }
    return json.dumps(io.getData("calendar_edit_form", params))


@app.route("/event/new_form", methods=["POST"])
def event_new_form():
    params = {
        "calendar_id": request.form.get('form_event_calendar', 0),
        "name": request.form.get('form_event_name', 0),
        "start": request.form.get('form_event_start', 0),
        "end": request.form.get('form_event_end', 0)
    }
    return json.dumps(io.getData("event_new", params))


@app.route("/event/edit/edit_form", methods=["POST"])
def event_edit_form():
    params = {
        "id": request.form.get('form_event_id', 0),
        "calendar_id": request.form.get('form_event_calendar', 0),
        "name": request.form.get('form_event_name', 0),
        "start": request.form.get('form_event_start', 0),
        "end": request.form.get('form_event_end', 0)
    }
    return json.dumps(io.getData("event_edit_form", params))


@app.route("/calendar/edit/<int:id>")
def calendar_edit(id):
    return render_template('index.html')


# @app.route("/event/edit/<int:id>")
# def event_edit(id):
#     return render_template('index.html')

@app.route("/event/edit/<int:calendar_id>/<int:event_id>")
def event_edit(calendar_id, event_id):
    return render_template('index.html')



@app.route("/")
@app.route("/login")
@app.route("/forgotpass")
@app.route("/newuser")
@app.route("/loggedin")
@app.route("/home")
@app.route("/calendar/new")
@app.route("/calendar/list")
@app.route("/event/new")
@app.route("/event/list")
def index():
    return render_template('index.html')

if __name__ == "__main__":
    app.run()
