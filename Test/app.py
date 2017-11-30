"""
    Flask
    this file is the core of the Calendar
    Sist oppdatert: Nils 30.10.2017
"""
#from mf_tasks import mf_page
import dataIO as io
import json
from flask import Flask, request, redirect, url_for, render_template, flash, session
import threading
import time
import send_notification_on_event as snoe
from mf_tasks import mf_page
import notifications as n

app = Flask(__name__)
app.secret_key = "any random string"


def logged_in(func,login):
    def f(*args,**kwargs):
        try:
            if login:
                return func(*args,**kwargs)
            else:
                print('You are not logged in')
                return index(*args,**kwargs)
        except KeyError as err:
            print(err)
            return index(*args,**kwargs)
    return f()


""" HOME """ #------------------------------------------------------------

@app.route("/loadViewEvents", methods=["POST"])
def loadViewEvents():
    return json.dumps(io.getData("loadview",request.get_json()))

@app.route("/getHTML")
def getHTML():
    html = request.args.get("html", None)
    with open('html/' + html +'.html', 'r') as f:
        template = f.read()
    data = {
        "template" : template,
        "data" : {},
        "notifications": n.flush()
    }
    return json.dumps(data)


@app.route("/getTMPL")
def getTMPL():
    tmpl = request.args.get("tmpl", None)
    data = request.args.get("data", None)
    print(data)
    params = {
        "id": request.args.get("id", None),
        "args": request.args
    }
    with open('tmpl/' + tmpl +'.tmpl', 'r') as f:
        template = f.read()
    jstring = {
        "template" : template,
        "data": io.getData(data, params),
        "notifications": n.flush()
    }
    return json.dumps(jstring)

""" USER """ #------------------------------------------------------------

@app.route("/login_form", methods=["POST"])
def login():
    return json.dumps(io.getData("login", request.form))

@app.route("/forgotpass_form", methods=["POST"])
def forgotpass_form():
    return json.dumps(io.getData("forgotpass", request.form))

@app.route("/edituser_form", methods=["POST"])
def edituser():
    return json.dumps(io.getData("edituser",request.form))

@app.route("/newuser_form", methods=["POST"])
def newuser():
    return json.dumps(io.getData("newuser", request.form))

@app.route("/loggout")
def loggout():
    return json.dumps(io.getData('loggout'),None)

@app.route("/reset_pass/<string:id>", methods=["GET"])
def reset_pass(id):
    return render_template('index.html')

@app.route("/reset_pass_form", methods=["POST"])
def reset_pass_form():
    params = {
        'id':request.form.get('id',0),
        'password':request.form.get('password', 0),
        'password_repeat':request.form.get('password_repeat', 0)
    }
    return json.dumps(io.getData("reset_pass_form",params))


""" CALENDAR """ #------------------------------------------------------------

@app.route("/calendar/new_form", methods=["POST"])
def calendar_new_form():
    return json.dumps(io.getData("calendar_new", request.form))

@app.route("/calendar/edit/edit_form", methods=["POST"])
def calendar_edit_form():
    return json.dumps(io.getData("calendar_edit_form", request.form))

@app.route("/calendar/edit/<int:id>")
def calendar_edit(id):
    return render_template('index.html')


""" EVENTS """ #------------------------------------------------------------

@app.route("/event/new_form", methods=["POST"])
def event_new_form():
    return json.dumps(io.getData("event_new", request.form))


@app.route("/event/edit/<int:calendar_id>/edit_form", methods=["POST"])
def event_edit_form(calendar_id):
    return json.dumps(io.getData("event_edit_form", request.form))


@app.route("/event/list/<int:calendar_id>")
def event_calendar(calendar_id):
    return json.dumps('event_list',calendar_id)

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
@app.route("/task/new")
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
