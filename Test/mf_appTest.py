


from flask import Flask, request, redirect, url_for, render_template, flash, session
import time
import json
app = Flask(__name__)

@app.route("/")
def index():
	with open("templates/home.html", "r") as f:
		html = f.read()
	return html

@app.route("/someContent")
def timeline():
	time.sleep(2)
	with open("templates/someContent.html", "r") as f:
		template = f.read()
	data = {
		'template': template,
		'data': {'a':1, 'b':2, 'c':3}
	}
	return json.dumps(data)

if __name__ == "__main__":
    app.run()
