"""
    Flask
    this file is the core of the Calendar

    Sist oppdatert: Sondre 02.10.2017

"""
import json
from flask import Flask, request, redirect, url_for, render_template, flash, session
app = Flask(__name__)
    
    
@app.route("/getHTML")

def getHTML(html):
    html = request.args.get('html')

    with open('html/' + html , 'r') as f:
        template = f.read()
        
    data = {
        'template' : template,
        'data' : {}
    }
    
    return json.dumps(data)

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
