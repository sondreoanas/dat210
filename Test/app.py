"""
    Flask
    this file is the core of the Calendar
    Sist oppdatert: Nils 03.10.2017
"""
import dataTmpl
import notifications
import back
import json
import time
from flask import Flask, request, redirect, url_for, render_template, flash, session
app = Flask(__name__)
    
lag = 0.4

@app.route("/getHTML")
def getHTML():
    html = request.args.get('html')
    with open('html/' + html +'.html', 'r') as f:
        template = f.read()
    data = {
        "template" : template,
        "data" : {}
    }
    return json.dumps(data)


@app.route("/getTMPL")
def getTMPL():
    tmpl = request.args.get('tmpl')
    data = request.args.get('data')
    id = request.args.get('id', None)

    with open('tmpl/' + tmpl +'.tmpl', 'r') as f:
        template = f.read()
    jstring = {
        "template" : template,
        "data": dataTmpl.getData(data, id)
    }
    return json.dumps(jstring)



@app.route("/login_form", methods=["POST"])
def login():
    username = request.form.get('username', 0)
    password = request.form.get('password', 0)

    return json.dumps({
        "success": back.valid_login(username, password)
    })

@app.route("/forgotpass_form", methods=["POST"])
def forgotpass():
    username = request.form.get('form_userid', 0)

    return json.dumps({
        "success": True,
        "data" : {
            "username" : username
        }
    })

@app.route("/newuser_form", methods=["POST"])
def newuser():
    email = request.form.get('form_new_email', 0)
    nickname = request.form.get('form_new_nick', 0)
    password = request.form.get('form_new_pass', 0)
    password_repeat = request.form.get('form_new_pass_repeat', 0)

    return json.dumps({
        "success": True,
        "data": {
            "email": email,
            "nickname": nickname
        }
    })


@app.route("/calendar/new_form", methods=["POST"])
def calendar_new_form():
    name = request.form.get('form_calendar_name', 0)
    public = request.form.get('form_calendar_public', 0)

    return json.dumps({
        "success": True,
        "data": {
            "id" : 21,
            "name" : name,
            "public" : public
        }
    })

@app.route("/calendar/edit/edit_form", methods=["POST"])
def calendar_edit_form():

    id = request.form.get('form_calendar_id', 0)
    name = request.form.get('form_calendar_name', 0)
    public = request.form.get('form_calendar_public', 0)

    return json.dumps({
        "success": True,
        "data": {
            "id" : id,
            "name" : name,
            "public" : public
        }
    })



@app.route("/event/new_form", methods=["POST"])
def event_new_form():
    calendar_id = request.form.get('form_event_calendar', 0)
    name = request.form.get('form_event_name', 0)
    start = request.form.get('form_event_start', 0)
    end = request.form.get('form_event_end', 0)

    return json.dumps({
        "success": True,
        "data": {
            "id" : 4545,
            "calendar_id" : calendar_id,
            "name" : name,
            "start" : start,
            "end" : end
        }
    })

@app.route("/event/edit/edit_form", methods=["POST"])
def event_edit_form():

    id = request.form.get('form_event_id', 0)
    calendar_id = request.form.get('form_event_calendar', 0)
    name = request.form.get('form_event_name', 0)
    start = request.form.get('form_event_start', 0)
    end = request.form.get('form_event_end', 0)

    return json.dumps({
        "success": True,
        "data": {
            "id" : id,
            "calendar_id" : calendar_id,
            "name" : name,
            "start" : start,
            "end" : end
        }
    })


@app.route("/calendar/edit/<int:id>")
def calendar_edit(id):
    return render_template('index.html')

@app.route("/event/edit/<int:id>")
def event_edit(id):
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
