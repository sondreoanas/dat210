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
    time.sleep(lag)
    html = request.args.get('html')
    with open('html/' + html +'.html', 'r') as f:
        template = f.read()
    data = {
        'template' : template,
        'data' : {}
    }
    return json.dumps(data)


@app.route("/getTMPL")
def getTMPL():
    time.sleep(lag)
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



@app.route("/login", methods=["POST"])
def login():
    username = request.form.get('username', 0)
    password = request.form.get('password', 0)

    return json.dumps({
        "successLogin": back.valid_login(username, password)
    })

@app.route("/newuser", methods=["POST"])
def newuser():
    time.sleep(lag)
    form_new_email = request.form.get('form_new_email', 0)
    form_new_nick = request.form.get('form_new_nick', 0)
    form_new_pass = request.form.get('form_new_pass', 0)
    form_new_pass_repeat = request.form.get('form_new_pass_repeat', 0)

    return json.dumps({
        "success": "true",
        "data": {
            "email": "din@epost.com",
            "nick": "Ditt nick"
        }
    })


@app.route("/calendar/new_form", methods=["POST"])
def calendar_new_form():
    form_calendar_new_name = request.form.get('form_calendar_new_name', 0)

    return json.dumps({
        "success": True,
        "data": {
            "name" : form_calendar_new_name
        }
    })

@app.route("/event/new_form", methods=["POST"])
def event_new_form():
    form_event_new_name = request.form.get('form_event_new_name', 0)

    return json.dumps({
        "success": True,
        "data": {
            "name" : form_event_new_name
        }
    })


@app.route("/calendar/edit/<int:id>")
def calendar_edit(id):
    return render_template('index.html')


@app.route("/")
@app.route("/loggedin")
@app.route("/home")
@app.route("/calendar/new")
@app.route("/calendar/list")
@app.route("/event/new")
def index():
    time.sleep(lag)
    return render_template('index.html')

if __name__ == "__main__":
    app.run()
