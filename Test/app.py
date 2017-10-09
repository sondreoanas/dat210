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
    with open('tmpl/' + tmpl +'.tmpl', 'r') as f:
        template = f.read()
    data = {
        'template' : template,
        "data": {
            "success": "true",
            "data": {
                "email": "din@epost.com",
                "nick": "Ditt nick"
            }
        }
    }
    return json.dumps(data)



@app.route("/login", methods=["POST"])
def login():
    time.sleep(lag)
    username = request.form.get('username', 0)
    password = request.form.get('password', 0)

    return json.dumps({
        'successLogin': back.valid_login(username,password)
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

@app.route("/")
def index():
    time.sleep(lag)
    return render_template('index.html')

if __name__ == "__main__":
    app.run()
