"""
    Flask
    this file is the core of the Calendar

    Sist oppdatert: Sondre 27.09.2017

"""
import back     #Back-end python script
import front    #Front-end python script
from flask import Flask, request, redirect, url_for, render_template, flash, session
app = Flask(__name__)

@app.route("/")
def index():
    data = '{}'
    json.dumps()

if __name__ == "__main__":
    app.run()
