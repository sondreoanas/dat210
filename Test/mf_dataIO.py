'''
	mf_app.py
	version			: 0.0.0
	last updated	: 18.11.2017
	name			:
	description		:
		What does this do?
			This returns templates to mf_app when mf_app requests it. mf_app requests templates when recieving an
			/getTMPL request.
		How to use it?
			Calls to theese methods are made from mf_app getTMPL().
'''
import mf_database
import mf_app
from flask import session
import notifications

def nav(request):
	return {
				"items":
				[
					{
						"title": "Home",
						"isparent": 0,
						"link": "home",
						"children": []
					},{
						"title": "Calendar",
						"isparent": 1,
						"link": "calendar",
						"children": [
							{
								"title": "New Calendar",
								"isparent": 0,
								"link": "calendar/new",
								"children": []
							},{
								"title": "My Calendars",
								"isparent": 0,
								"link": "calendar/list",
								"children": []
							}
						]
					},{
						"title": "Event",
						"isparent": 1,
						"link": "/event",
						"children": [
							{
								"title": "New Event",
								"isparent": 0,
								"link": "event/new",
								"children": []
							},{
								"title": "My Events",
								"isparent": 0,
								"link": "event/list",
								"children": []
							}
						]
					},{
						"title": "Tasks",
						"isparent": 1,
						"link": "/task",
						"children": [
							{
								"title": "New Task",
								"isparent": 0,
								"link": "task/new",
								"children": []
							},{
								"title": "My Tasks",
								"isparent": 0,
								"link": "task/list",
								"children": []
							}
						]
					},{
						"title": "Loggout",
						"isparent": 0,
						"link": "/loggedout",
						"children": []
					}
				]
		}

def calendar_list(request):
	if not mf_app.isLoggedIn():
		return -1
	userId = session["id"]
	
	calendars = mf_database.getAllCalendarsOfUser(userId)
	if calendars == -1:
		# TODO: add notification stuff
		return -1
	
	return [{
		  "id": c["id"],
		  "name": c["name"],
		  "rights": c["adminLevel"], # rename
		  "public": c["public"]
						  } for c in calendars]
def loggout(request):
	if not mf_app.isLoggedIn():
		return -1
	username = session["username"]
	
	return {
		"success": True,
		"data": {
			'username': username
		}
	}
def frontmenu(request):
	return {
                "items":
                            [
                                {
                                    "title": "Login",
                                    "isparent": 0,
                                    "link": "login",
                                    "children": []
                                },{
                                    "title": "New user",
                                    "isparent": 0,
                                    "link": "newuser",
                                    "children": []
                                },{
                                    "title": "Forgot password?",
                                    "isparent": 0,
                                    "link": "forgotpass",
                                    "children": []
                                }
                            ]
            }

def calendar_edit(request):
	if not mf_app.isLoggedIn():
		# TODO: add notification
		return -1
	userId = session["id"]
	
	calendarId = request.args.get("id", None)
	
	if calendarId is None:
		# TODO: add notification
		return -1
	
	calendar = mf_database.getCalendarOfUser(userId, calendarId)
	
	if calendar == -1:
		# TODO: add notification
		return -1
	
	return {
		"id": calendar["id"],
		"name": calendar["name"],
		"public": calendar["public"],
	}

def event_calendar(request): # TODO: why is it sending back exactly the same thing recieved?
	calendarId = request.args.get("calendar_id", None)
	
	if calendarId is None:
		# TODO: add notification
		return -1
	
	return {
		"calendar_id": calendarId
	}

def event_calendar_list(request):
	if not mf_app.isLoggedIn():
		# TODO: add notification
		return -1
	userId = session["id"]
	
	calendarId = request.args.get("calendar_id", None)
	
	if calendarId is None:
		# TODO: add notification
		return -1
	
	events = mf_database.getEventsOfCalenderOfUser(userId, calendarId)
	if events == -1:
		# TODO: add notification
		return -1
	
	formattedEvents = [{
			"id": e["id"],
			"calendar_id": calendarId,
			"name": e["name"],
			"start": str(e["start"]),
			"end": str(e["end"]),
		} for e in events]
	
	return formattedEvents
def event_edit(request):
	eventId = request.args.get("event_id", None)
	
	if eventId == -1:
		return -1
	
	event = mf_database.getEvent(eventId)
	
	if event == -1:
		return -1
	
	returnData = {
		"notifications":notifications.flush(),
		"success": True,
		"data": {
			"id" : eventId,
			"calendar_id": event["calendarId"],
			"calendars" : calendar_list(request),
			"name": event["name"],
			"start": str(event["start"]),
			"end":  str(event["end"])
		}
	}
	return returnData

def task_list(request):
	if not mf_app.isLoggedIn():
		return -1
	userId = session["id"]

	tasks = mf_database.getTasksOfUser(userId)
	if tasks == -1:
		# TODO: add notification stuff
		return -1

	return [{
		  "id": t["id"],
		  "name": t["name"]
						  } for t in tasks if t["parentId"] == None]



def task_edit(request):
	if not mf_app.isLoggedIn():
		return -1
	userId = session["id"]

	taskId = request.args.get("id", None)
	if taskId is None:
		# TODO: add notification
		return -1

	tasks = mf_database.getTask(userId)
	if tasks == -1:
		# TODO: add notification stuff
		return -1


	return [{
		  "id": t["id"],
		  "name": t["name"]
						  } for t in tasks if t["parentId"] == None]






