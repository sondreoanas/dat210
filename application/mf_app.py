'''
	mf_app.py
	version			: 0.1.3
	last updated	: 03.12.2017
	name			:
	description		:
		What does this do?
			This control the communication between the user and
		How to use it?
			Run this to start the server
'''
import json
import datetime
from flask import Flask, request, redirect, url_for, render_template, flash, session, g
import threading
import time
import send_notification_on_event
import notifications
import mf_database
import mf_dataIO
#from mf_tasks import mf_page
import mysql.connector
import re
import os
from werkzeug.security import check_password_hash, generate_password_hash
import smtplib
import random

app = Flask(__name__)
#app.register_blueprint(mf_page)
app.secret_key = "any random string2"
#app.secret_key = str(random.randint(0,9999999999999999999))

@app.route("/reset_pass_form", methods=["POST"])
def reset_pass_form():
	returnData = {
			"success": False,
			"notifications": None
		}
	
	#newPassword = os.urandom(5).hex()
	
	urlEnding = request.form.get('id', None)
	newPassword = request.form.get('password', None)
	newPasswordRepeat = request.form.get('password_repeat', None)
	
	if urlEnding is None or newPassword is None or newPasswordRepeat is None or newPassword != newPasswordRepeat:
		return formatJsonWithNotifications(returnData)
	
	newHashedPassword = generate_password_hash(newPassword, method='pbkdf2:sha256',salt_length=8)
	
	wasSuccessful = mf_database.resetPasswordOfUser(urlEnding, newHashedPassword)
	if wasSuccessful == -1: # -1 is not successful
		return formatJsonWithNotifications(returnData)
	
	returnData["success"] = True
	return formatJsonWithNotifications(returnData)

@app.route("/reset_pass/<string:urlEnding>", methods=["GET"])
def reset_pass(urlEnding):
	return render_template('index.html')

@app.route("/forgotpass_form", methods=["POST"])
def sendResetPassworEmail():
	returnData = {
			"success": False,
			"notifications": None
		}
	
	email = request.form.get("form_userid",None)
	
	if email is None:
		return formatJsonWithNotifications(returnData)
	
	# create link
	urlEnding = os.urandom(10).hex()
	link = "http://127.0.0.1:5000/reset_pass/" + urlEnding
	
	# generate reset passwor link
	result = mf_database.getUserIdPassword(email)
	if result == -1:
		return formatJsonWithNotifications(returnData)
	(userId, _) = result
	
	wasSuccessful = mf_database.createResetPassworLink(userId, urlEnding)
	if wasSuccessful == -1: # -1 is not successful
		return formatJsonWithNotifications(returnData)
	
	# send mail with password link
	subject = "Annual Cycle: reset password"
	text = "Did you forget your password?\nClick this link to reset your password: " + link + "\n" \
		"The new password will be sent to your email."
	sendMail(subject, text, email)
	
	#
	returnData["success"] = True
	return formatJsonWithNotifications(returnData)

@app.route("/event/edit/<int:calendar_id>/edit_form", methods=["POST"])
def editEventForm(calendar_id):
	returnData = {
			"success": False,
			#event description mangler + intervall + terminate_date
			"data": {
				"id" : None,
				"calendar_id": None,
				"calendars" : None,
				"name": None,
				"start": None,
				"end":  None
			},
			"notifications": None
		}
	
	eventId = request.form.get('form_event_id', None)
	newCalendarId = request.form.get('form_event_calendar', None)
	newName = request.form.get('form_event_name', "")
	newStartPicker = request.form.get('form_event_start', None)
	newEndPicker = request.form.get('form_event_end', None)
	
	returnData["data"]["id"] = eventId
	returnData["data"]["calendar_id"] = newCalendarId
	returnData["data"]["name"] = newName
	returnData["data"]["start"] = newStartPicker
	returnData["data"]["end"] = newEndPicker
	calendars = mf_dataIO.calendar_list(request)
	if calendars == -1:
		return formatJsonWithNotifications(returnData)
	returnData["data"]["calendars"] = calendars
	
	if eventId is None or newCalendarId is None or newName == "" or newStartPicker is None or newEndPicker is None:
		return formatJsonWithNotifications(returnData)
	
	if not isLoggedIn():
		return formatJsonWithNotifications(returnData)
	userId = session["id"]
	
	try:
		newStart = datetime.datetime.strptime(newStartPicker,"%Y-%m-%dT%H:%M:%S.%fZ")
		newEnd = datetime.datetime.strptime(newEndPicker,"%Y-%m-%dT%H:%M:%S.%fZ")
	except:
		return formatJsonWithNotifications(returnData)
	
	wasSuccessful = mf_database.editEvent(eventId, userId, newName, None, newStart.isoformat(), newEnd.isoformat(), None, newCalendarId)
	
	if wasSuccessful == -1: # -1 is not successful
		return formatJsonWithNotifications(returnData)
	
	returnData["success"] = True
	return formatJsonWithNotifications(returnData)

@app.route("/calendar/edit/edit_form", methods=["POST"])
def calendar_edit_form():
	calendarId = request.form.get('form_calendar_id', None)
	newCalendarName = request.form.get('form_calendar_name', None)
	newPublicStatus = request.form.get('form_calendar_public',None)
	
	returnData = {
		"success": False,
		"data": {
			"id": calendarId,
			"name": newCalendarName,
			"public": None
		},
		"notifications": None
	}
	
	if calendarId is None or newCalendarName is None:
		notifications.append(notifications.notification(6))
		return formatJsonWithNotifications(returnData)
	
	if not isLoggedIn():
		notifications.append(notifications.notification(6))
		return formatJsonWithNotifications(returnData)
	userId = session["id"]
	
	newIsPublic = True if newPublicStatus == "public" else False
	
	returnData["data"]["public"] = newIsPublic
	
	wasSuccessful = mf_database.editCalendar(newCalendarName, newIsPublic, calendarId, userId)
	
	if wasSuccessful == -1: # -1 is not successful
		notifications.append(notifications.notification(6))
		return formatJsonWithNotifications(returnData)
	
	returnData["success"] = True
	return formatJsonWithNotifications(returnData)

@app.route("/calendar/new_form", methods=["POST"])
def createNewCalendar():
	returnData = {
		"success": False,
		"data": {
			"id" : None,
			"name" : None,
			"public" : None
		},
		"notifications": None
	}
	
	if not isLoggedIn():
		return formatJsonWithNotifications(returnData)
	userId = session["id"]
	
	calendarName = request.form.get("form_calendar_name",None)
	publicStatus = request.form.get("form_calendar_public",None) # is "public" if public and None if private
	
	if calendarName is None:
		return formatJsonWithNotifications(returnData)
	
	returnData["data"]["name"] = calendarName
	returnData["data"]["public"] = publicStatus
	
	isPublic = True if publicStatus == "public" else False
	
	calendarId = mf_database.createNewCalendar(userId, calendarName, isPublic)
	
	if calendarId == -1:
		return formatJsonWithNotifications(returnData)
	
	returnData["data"]["id"] = calendarId
	returnData["success"] = True
	
	return formatJsonWithNotifications(returnData)

@app.route("/event/new_form", methods=["POST"])
def createNewEventFromForm():
	calendarId = request.form.get("form_event_calendar", None)
	startPicker = request.form.get('form_event_start', None)
	endPicker =  request.form.get('form_event_end', None)
	eventName = request.form.get('form_event_name', None)
	
	returnData = {
		"success": False,
		"data": {
			"id" : None,
			"calendar_id": None,
			"name": None,
			"start": None,
			"end": None
		},
		"notifications": None
	}
	
	if calendarId is None or startPicker is None or endPicker is None or eventName is None:
		return formatJsonWithNotifications(returnData)
	
	try:
		start = datetime.datetime.strptime(startPicker,"%Y-%m-%dT%H:%M:%S.%fZ")
		end = datetime.datetime.strptime(endPicker,"%Y-%m-%dT%H:%M:%S.%fZ")
	except BaseException as err:
		# TODO: notification
		return formatJsonWithNotifications(returnData)
	
	eventId = mf_database.createNewEvent(eventName, start.isoformat(), end.isoformat(), calendarId)
	
	if eventId == -1:
		return formatJsonWithNotifications(returnData)
	
	returnData["success"] = True
	returnData["data"]["id"] = eventId
	returnData["data"]["calendar_id"] = calendarId
	returnData["data"]["name"] = eventName
	returnData["data"]["start"] = time.mktime(start.timetuple()) * 1000 # unit milliseconds since 1970 1st jan
	returnData["data"]["end"] = time.mktime(end.timetuple()) * 1000 # unit milliseconds since 1970 1st jan
	
	return formatJsonWithNotifications(returnData)

@app.route("/loggout") # old
@app.route("/loggedout") # old
@app.route("/logout")
def logOut():
	if isLoggedIn():
		session.pop("id")
		session.pop("username")
	return render_template('index.html')

@app.route("/task/new_form", methods=["POST"])
def createNewTask():
	returnData = {
		"success": False,
		"data": {
			"id" : None, # id of newly created task
			"calendar_id": None, # id of calendar task is added to
			"name": None, # name of newly created task
			"todos": None, # list of names of todos
			"interval": None # dictionary of parameters describing the interval
		},
		"notifications": None
	}
	
	if not isLoggedIn():
		return formatJsonWithNotifications(returnData)
	userId = session['id']
	
	calendarId = request.form.get('form_task_calendar', None)
	taskName = request.form.get('form_task_name', None)
	
	if calendarId is None or taskName is None:
		return formatJsonWithNotifications(returnData)
	
	# get and format interval
	intervalData = {name:value for name, value in request.form.items()} # convert from multiDict to dict
	formattedInterval = intervalDataToString(intervalData)
	if formattedInterval == -1:
		formatJsonWithNotifications(returnData)
	
	# create parent task
	taskId = mf_database.createNewTask(userId, taskName, "Some placeholder description", formattedInterval, 0,
		calendarId, None)
	if taskId == -1:
		return formatJsonWithNotifications(returnData)
	
	# add todos
	todos = request.form.getlist("todos")
	for todo in todos: # TODO: don't commit() before all done
		mf_database.createNewTask(userId, todo, "Some placeholder description", formattedInterval, None, None, taskId)
	
	#
	returnData["success"] = True
	returnData["data"]["id"] = taskId
	returnData["data"]["calendar_id"] = calendarId
	returnData["data"]["name"] = taskName
	returnData["data"]["todos"] = todos
	returnData["data"]["interval"] = intervalData
	
	return formatJsonWithNotifications(returnData)

@app.route("/editTask", methods=["POST"])
@app.route("/task/edit/editTask", methods=["POST"])
def editTask():
	returnData = {
		"success": False,
		"notifications": None
	}
	
	if not isLoggedIn():
		return formatJsonWithNotifications(returnData)
	userId = session["id"]
	
	newTaskName = request.form.get('form_task_name', None)
	newCalendarId = request.form.get('form_task_calendar', None)
	taskId = request.form.get('form_task_id', None) # This is new!
	
	if newTaskName is None or newCalendarId is None or taskId is None:
		return formatJsonWithNotifications(returnData)
	
	intervalData = {name:value for name, value in request.form.items()} # converting from multiDict to dict
	formattedNewInterval = intervalDataToString(intervalData)
	if formattedNewInterval == -1:
		formatJsonWithNotifications(returnData)
	
	# delete old task
	mf_database.deleteTask(userId, taskId)
	
	# create new Task
	# # create parent task
	taskId = mf_database.createNewTask(userId, newTaskName, "Some placeholder description", formattedNewInterval, 0,
		newCalendarId, None)
	if taskId == -1:
		return formatJsonWithNotifications(returnData)
	
	# # add todos
	todos = request.form.getlist("todos")
	for todo in todos: # TODO: don't commit() before all done
		mf_database.createNewTask(userId, todo, "Some placeholder description", formattedNewInterval, None, None, taskId)
	
	returnData["success"] = True
	return formatJsonWithNotifications(returnData)

@app.route("/getTasks", methods=["POST"])
@app.route("/getTask", methods=["POST"])
def getTasks():
	returnData = {
		"success": False,
		"tasks": [],
		"notifications": None
	}
	
	if not isLoggedIn():
		return formatJsonWithNotifications(returnData)
	userId = session["id"]
	
	tasks = mf_database.getTasksOfUser(userId)
	
	if tasks == -1:
		return formatJsonWithNotifications(returnData)
	
	returnData["tasks"] = tasks
	
	return formatJsonWithNotifications(returnData)

@app.route("/setTaskDone", methods=["POST"])
def setTaskDone():
	returnData = {
		"success": False,
		"notifications": None
	}
	
	taskId = request.get_json().get("taskId", None)
	
	if taskId is None:
		return formatJsonWithNotifications(returnData)
	
	wasSuccessful = mf_database.setTaskDone(taskId)
	
	if wasSuccessful == -1: # -1 is not successful
		return formatJsonWithNotifications(returnData)
	
	returnData["success"] = True
	
	return formatJsonWithNotifications(returnData)

@app.route("/addNewEvent", methods=["POST"]) # old
@app.route("/createNewEvent", methods=["POST"])
def createNewEventFromTask():
	returnData = {
		"success": False,
		"isSuccess": False,
		"notifications": None
	}
	
	calendarId = request.get_json().get("calendarId", None)
	eventName = request.get_json().get("eventName", None)
	startMills = request.get_json().get("start", None)
	endMills = request.get_json().get("end", None)
	
	if calendarId is None or eventName is None or startMills is None or endMills is None:
		return formatJsonWithNotifications(returnData)
	
	start = datetime.datetime.fromtimestamp(int(startMills / 1000)).strftime('%Y-%m-%d %H:%M:%S')
	end = datetime.datetime.fromtimestamp(int(endMills / 1000)).strftime('%Y-%m-%d %H:%M:%S')
	
	wasSuccessful = mf_database.createNewEvent(eventName, start, end, calendarId)
	if wasSuccessful == -1: # -1 is not successful
		return formatJsonWithNotifications(returnData)
	
	returnData["success"] = True
	returnData["isSuccess"] = True
	
	return formatJsonWithNotifications(returnData)

@app.route("/resetTasks", methods=["POST"])
def resetTasks():
	returnData = {
		"success": False,
		"notifications": None
	}
	
	taskId = request.get_json().get("taskId", None)
	newTimeStamp = request.get_json().get("newTimeStamp", None)
	
	if taskId is None or newTimeStamp is None:
		return formatJsonWithNotifications(returnData)
	
	wasSuccessful = mf_database.resetTask(taskId, newTimeStamp)
	
	if wasSuccessful == -1: # -1 is not successful
		return formatJsonWithNotifications(returnData)
	
	returnData["success"] = True
	
	return formatJsonWithNotifications(returnData)

@app.route("/loadViewEvents", methods=["POST"])
def loadViewEvents():
	returnData = {
		"success": False,
		"events": [],
		"notifications": None
	}
	
	if not isLoggedIn():
		return formatJsonWithNotifications(returnData)
	
	userId = session["id"]
	
	startTimeStamp = request.get_json().get('start', None)
	endTimeStamp = request.get_json().get('end', None)
	
	if startTimeStamp is None or endTimeStamp is None:
		return formatJsonWithNotifications(returnData)
	
	try:
		start = datetime.datetime.fromtimestamp(startTimeStamp / 1000.0).isoformat()
		end = datetime.datetime.fromtimestamp(endTimeStamp / 1000.0).isoformat()
	except:
		return formatJsonWithNotifications(returnData)
	
	result = mf_database.getAllEventsOfUser(userId, start, end)
	
	if result == -1:
		return formatJsonWithNotifications(returnData)
	
	events = [{
			"name": r["name"],
			"start": time.mktime(r["start"].timetuple()) * 1000,
			"end": time.mktime(r["end"].timetuple()) * 1000
		} for r in result]
	
	returnData["success"] = True
	returnData["events"] = events
	
	return formatJsonWithNotifications(returnData)

@app.route("/login_form", methods=["POST"])
def login():
	returnData = {
		"success": False,
		"data": {
			"username" : None
		},
		"notifications": None
	}
	
	email = request.form.get('username', None)
	passwordFromClient = request.form.get('password', None)
	
	returnData["data"]["username"] = email
	
	if email is None or passwordFromClient is None:
		notifications.append(notifications.notification(1))
		return formatJsonWithNotifications(returnData)
	
	# get password
	result = mf_database.getUserIdPassword(email)
	
	if result == -1:
		notifications.append(notifications.notification(1))
		return formatJsonWithNotifications(returnData)
	
	(userId, hashedPasswordFromDatabase) = result
	
	if check_password_hash(hashedPasswordFromDatabase, passwordFromClient):
		session["id"] = userId
		session["username"] = email
		returnData["success"] = True
		return formatJsonWithNotifications(returnData)
	else:
		notifications.append(notifications.notification(1))
		return formatJsonWithNotifications(returnData)

@app.route("/newuser_form", methods = ["POST"])  # old
@app.route("/createNewUser", methods = ["POST"])
def createNewUser():
	returnData = {
		"data":{
			"email": None,
			"nickname": None
		},
		"success": False,
		"notifications": None
	}
	
	email = request.form.get('form_new_email', "")
	nickname = request.form.get('form_new_nick', "")
	password = request.form.get('form_new_pass', "")
	repeat_password = request.form.get('form_new_pass_repeat', "")
	
	returnData["data"]["email"] = email
	returnData["data"]["nickname"] = nickname
	
	if email == "" or nickname == "" or password == "" or repeat_password == "":
		notifications.append(notifications.notification(3))
		return formatJsonWithNotifications(returnData)
	if password != repeat_password:
		notifications.append(notifications.notification(2))
		return formatJsonWithNotifications(returnData)
	
	# valid username and password
	# # proper username?
	match = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', email)
	if match is None:
		notifications.append(notifications.notification(3)) # TODO: replace with better notifications
		return formatJsonWithNotifications(returnData)
	# # usename already in use?
	uniqueUsername = mf_database.checkEmailInUse(email)
	
	if uniqueUsername == -1: # error happened
		notifications.append(notifications.notification(3))
		return formatJsonWithNotifications(returnData)
	
	if not uniqueUsername:
		notifications.append(notifications.notification(3))
		return formatJsonWithNotifications(returnData)
	
	# # proper password?
	#TODO: some password validity test
	
	# hash password and create salt
	salt = os.urandom(10).hex()
	hashedPassword = generate_password_hash(password, method='pbkdf2:sha256',salt_length=8)
	
	# create user
	userId = mf_database.createUser(email, hashedPassword, salt, nickname)
	
	if userId == -1:
		notifications.append(notifications.notification(3))
		return formatJsonWithNotifications(returnData)
	
	# create standard calendar
	calendarName = nickname + "\'s calendar"
	# # add in calendar
	result = mf_database.createNewCalendar(userId, calendarName, False)
	
	if result == -1:
		notifications.append(notifications.notification(3))
		return formatJsonWithNotifications(returnData)
	
	#
	returnData["success"] = True
	return formatJsonWithNotifications(returnData)

@app.route("/getHTML")
def getHTML():
	# takes a html filename and returns the file content as json in the following format:
	'''
	return = {
		"success": True/False,					# was the file loading successful
		"template" : template,					# this is file
		"data" : {},							# additional data belonging to the file
		"notifications": notifications.flush()	#
	}
	'''
	returnData = {
		"success": True,		# was the file loading successful
		"template": None,		# the file to get
		"data": {},				# additional data belonging to the file
		"notifications": None	#
	}
	
	html = request.args.get("html", None)
	if html is None:
		return formatJsonWithNotifications(returnData)
	with open('html/' + html + '.html', 'r') as f:
		template = f.read()
	returnData["success"] = True
	returnData["template"] = template
	
	return formatJsonWithNotifications(returnData)

@app.route("/getTMPL")
def getTMPL():
	returnData = {
		"success": False,
		"template": None,
		"data": None,
		"notifications": None
	}
	
	templateFile = request.args.get("tmpl", None)
	data = request.args.get("data", None)
	#someId = request.args.get("id", None)
	arguments = request.args
	
	if templateFile is None or arguments is None:
		# someId and data is tested for when used in the navigation structure
		return formatJsonWithNotifications(returnData)
	
	try:
		with open('tmpl/' + templateFile +'.tmpl', 'r') as f:
			template = f.read()
	except:
		return formatJsonWithNotifications(returnData)
	
	if data is not None:# let returnData["data"] be None if data is None
		dataIOFunction = getattr(mf_dataIO, data, -1)
		if dataIOFunction == -1:
			printError("ERROR: did not find data: \"" + data + "\"")
			return formatJsonWithNotifications(returnData)
			
		else:
			result = dataIOFunction(request)
			if result == -1:
				return formatJsonWithNotifications(returnData)
			returnData["data"] = result
	
	returnData["template"] = template
	returnData["success"] = True
	
	return formatJsonWithNotifications(returnData)

""" Helper functions """  # ------------------------------------------------------------
def printError(message):
	print("\033[91m" + str(message))

def formatJsonWithNotifications(returnData):
	returnData["notifications"] = notifications.flush()
	return json.dumps(returnData)

def isLoggedIn():
	if "id" in session:
		return True
	else:
		return False

def sendMail(subject, text, email):
	#format
	message = 'Subject: {}\n\n{}'.format(subject, text)
	
	# login
	server = smtplib.SMTP_SSL('smtp.gmail.com', 465)  # Enter SSL configuration for domain
	server.ehlo()
	senderEmail = "dat210.calendar@gmail.com"
	senderPassword = "Dat210calendar"
	server.login(senderEmail, senderPassword)
	# # send
	server.sendmail(senderEmail, email, message)
	server.close()

def intervalDataToString(intervalData):
	'''
	This function takes in a dictionary following attributes:
		"form_task_interval_year", "form_task_interval_month",
		"form_task_interval_week", "form_task_interval_day",
		"form_task_interval_month_year", "form_task_interval_week_year",
		"form_task_interval_week_month", "form_task_interval_day_year"
		form_task_interval_day_month", "form_task_interval_day_week"
	Some of the attributes may be missing depending on the type of interval
	
	The data returned could look like this
		Example of interval:
			formattedInterval = "{weekInterval: {start: new Date(\"08 nov 2017\"), modulus: 2},dayNrInWeek: 2}"
		
		More general example of interval:
			formattedInterval = {
				yearInterval: {start: new Date("2018"), modulus = 2},
				monthInterval: null,
				monthNrInYear: null,
				weekInterval: {start: new Date("this week"), modulus: 2},
				weekNrInMonth: null,
				weekNrInYear: null,
				dayInterval: {start: new Date("today"), modulus: 2},
				dayNrInWeek: null,
				dayNrInMonth: 5,
				dayNrInYear: null
			}
	Errors cause -1 to be returned
	'''

	intervalDict = {}
	if "form_task_interval_year" in intervalData:
		intervalDict["yearInterval"] = {}
		intervalDict["yearInterval"]["start"] = datetime.datetime.now().isoformat()
		intervalDict["yearInterval"]["modulus"] = int(intervalData["form_task_interval_year"])

	elif "form_task_interval_month" in intervalData:
		intervalDict["monthInterval"] = {}
		intervalDict["monthInterval"]["start"] = datetime.datetime.now().isoformat()
		intervalDict["monthInterval"]["modulus"] = int(intervalData["form_task_interval_month"])

	elif "form_task_interval_week" in intervalData:
		intervalDict["weekInterval"] = {}
		intervalDict["weekInterval"]["start"] = datetime.datetime.now().isoformat()
		intervalDict["weekInterval"]["modulus"] = int(intervalData["form_task_interval_week"])

	elif "form_task_interval_day" in intervalData:
		intervalDict["dayInterval"] = {}
		intervalDict["dayInterval"]["start"] = datetime.datetime.now().isoformat()
		intervalDict["dayInterval"]["modulus"] = int(intervalData["form_task_interval_day"])
	else:
		return -1
	
	# month
	if "form_task_interval_month_year" in intervalData:
		months = ["January", "February", "March", "April", "May", "June",
				  "July", "August", "September", "October", "November", "December"]
		if intervalData["form_task_interval_month_year"] not in months:
			printError("ERROR: Did not recognize month.")
			return -1
		m = months.index(intervalData["form_task_interval_month_year"])
		intervalDict["monthNrInYear"] = m
	
	# week
	if "form_task_interval_week_year" in intervalData:
		intervalDict["weekNrInYear"] = int(intervalData["form_task_interval_week_year"]) - 1

	elif "form_task_interval_week_month" in intervalData:
		intervalDict["weekNrInMonth"] = int(intervalData["form_task_interval_week_month"]) - 1
	
	# day
	if "form_task_interval_day_year" in intervalData:
		intervalDict["dayNrInYear"] = int(intervalData["form_task_interval_day_year"]) - 1

	elif "form_task_interval_day_month" in intervalData:
		intervalDict["dayNrInMonth"] = int(intervalData["form_task_interval_day_month"]) - 1

	elif "form_task_interval_day_week" in intervalData:
		days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
		if not intervalData["form_task_interval_day_week"] in days:
			return -1
		d = days.index(intervalData["form_task_interval_day_week"])
		intervalDict["dayNrInWeek"] = d

	return json.dumps(intervalDict)

""" Default """  # ------------------------------------------------------------

@app.route("/calendar/edit/<int:id>")  # TODO: check can be merged with default? (below)
def calendar_edit(id):
	return render_template('index.html')


@app.route("/event/edit/<int:calendar_id>/<int:event_id>")  # TODO: check can be merged with default? (below)
def event_edit(calendar_id, event_id):
	return render_template('index.html')


@app.route("/task/edit/<int:task_id>")  # TODO: check can be merged with default? (below)
def task_edit(task_id):
	return render_template('index.html')


@app.route("/home/<int:start>/<int:zoom>")  # TODO: check can be merged with default? (below)
def home_focus(start, zoom):
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
@app.route("/task/new")
@app.route("/task/list")
def index():
	if "notifList" not in session:
		session["notifList"] = []
	return render_template('index.html')


""" Threading """  # ------------------------------------------------------------

class threadingnotification(object):
	#  Threading class for sending email notification
	
	def __init__(self, interval = 1):
		""" Constructor
		:type interval: int
		:param interval: Check interval, in seconds
		"""
		self.interval = interval
		
		thread = threading.Thread(target = self.run, args = ())
		thread.daemon = True  # Daemonize thread
		thread.start()  # Start the execution
	
	def run(self):
		""" Method that runs forever """
		send_notification_on_event.run_email_eventnotification()
		
		time.sleep(self.interval)


if __name__ == "__main__":
	th = threadingnotification()
	app.run()
