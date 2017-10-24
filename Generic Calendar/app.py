"""
    Flask
    this file is the core of the Calendar
    Sist oppdatert: Nils 03.10.2017
"""
import back
import json
import time
from flask import Flask, request, redirect, url_for, render_template, flash, session
app = Flask(__name__)


@app.route("/loadViewEvents", methods=["POST"])
def loadViewEvents():
    start = request.form.get('start', 0);
    end = request.form.get('end', 0);
    print("start: " + str(start))
    print("end: " + str(end))

    return json.dumps({
        "events":[
            {
                "start": 1505599200000,
                "end": 1505772000000,
                "name": "LAN"
            },
            {
                "start": 1505685600000,
                "end": 1505858400000,
                "name": "Festival"
            },
            {
                "start": 1505732400000,
                "end": 1505818800000,
                "name": "Prepare for exam"
            },
            {
                "start": 1505890800000,
                "end": 1505905200000,
                "name": "Exam"
            }
        ]
    })

@app.route("/getHTML")
def getHTML():
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
    tmpl = request.args.get('tmpl')
    with open('tmpl/' + tmpl +'.tmpl', 'r') as f:
        template = f.read()
    data = {
        'template' : template,
        'data' : {
                "skills": ["js", "html", "css"],
                "showSkills": 1
                }
    }
    return json.dumps(data)


@app.route("/")
def new_event():
    pass

@app.route("/login")
def login(username, password):
    data = request.json
    bolean = back.valid_login(data['username'],data['password'])
    return json.dumps(bolean)

@app.route("/")
def index():
    return render_template('index.html')

if __name__ == "__main__":
    app.run()
