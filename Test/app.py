"""
    Flask
    this file is the core of the Calendar
    Sist oppdatert: Nils 30.10.2017
"""
from mf_tasks import mf_page
import dataIO as io
import json
from flask import Flask, request, redirect, url_for, render_template, flash, session
import threading
import time
import send_notification_on_event as snoe

app = Flask(__name__)
app.register_blueprint(mf_page)
app.secret_key = "any random string"

""" HOME """ #------------------------------------------------------------

@app.route("/loadViewEvents", methods=["POST"])
def loadViewEvents():
    if not session['login']: return render_template('index.html')
    params = {
        "load_start": request.get_json().get('start', 0),
        "load_end": request.get_json().get('end', 0)
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

""" USER """ #------------------------------------------------------------

@app.route("/login_form", methods=["POST"])
def login():
    params = {
        "username": request.form.get('username', 0),
        "password": request.form.get('password', 0)
    }
    data = io.getData("login", params)
    if data['success']:
        #session['id'] = data['success']
        session['username'] = params['username']
        session['login'] = True
    else:
        print('failed to log in')
    return json.dumps(data)

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

@app.route("/loggout")
def loggout():
    return json.dumps(io.getData('loggout'))

""" CALENDAR """ #------------------------------------------------------------

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

@app.route("/calendar/edit/<int:id>")
def calendar_edit(id):
    return render_template('index.html')


""" EVENTS """ #------------------------------------------------------------

@app.route("/event/new_form", methods=["POST"])
def event_new_form():
    params = {
        "calendar_id": request.form.get('form_event_calendar', 0),
        "name": request.form.get('form_event_name', 0),
        "start": request.form.get('form_event_start', 0),
        "end": request.form.get('form_event_end', 0)
    }
    return json.dumps(io.getData("event_new", params))


@app.route("/event/edit/<int:calendar_id>/edit_form", methods=["POST"])
def event_edit_form(calendar_id):
    params = {
        "id": request.form.get('form_event_id', 0),
        "old_calendar_id": calendar_id,
        "calendar_id": request.form.get('form_event_calendar', 0),
        "name": request.form.get('form_event_name', 0),
        "start": request.form.get('form_event_start', 0),
        "end": request.form.get('form_event_end', 0)
    }
    return json.dumps(io.getData("event_edit_form", params))


@app.route("/event/list/<int:calendar_id>")
def event_calendar(calendar_id):

    return render_template('index.html')

@app.route("/event/edit/<int:calendar_id>/<int:event_id>")
def event_edit(calendar_id, event_id):
    return render_template('index.html')

@app.route("/home/<int:start>/<int:zoom>")
def home_focus(start, zoom):
    return render_template('index.html')

@app.route("/task/new_form", methods=["POST"])
def task_new_form():
    return json.dumps(io.getData("task_new", request.form))


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

""" Threading""" #------------------------------------------------------------

class threadingnotification(object):
    #  Threading class for sending email notification

    def __init__(self, interval=1):
        """ Constructor
        :type interval: int
        :param interval: Check interval, in seconds
        """
        self.interval = interval

        thread = threading.Thread(target=self.run, args=())
        thread.daemon = True                            # Daemonize thread
        thread.start()                                  # Start the execution

    def run(self):
        """ Method that runs forever """
        snoe.run_email_eventnotification()

        time.sleep(self.interval)

if __name__ == "__main__":

    th = threadingnotification()

    app.run()
