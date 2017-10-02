"""
    Flask
    this file is the core of the Calendar

    Sist oppdatert: Sondre 27.09.2017

"""
import back_test     #Back-end python script
import json
from flask import Flask, request, redirect, url_for, render_template, flash, session
app = Flask(__name__)

@app.route("/test")
def test():
    data = test_db()
    return json.dumps(data)

@app.route("/")
def index():
    return render_template('index.html')

if __name__ == "__main__":
    app.run()
