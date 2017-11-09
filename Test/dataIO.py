import back_user
import back_event
import back_db as db
import time
import security
import notifications as n
import datetime
from flask import session
import smtplib

sender_user = 'dat210.calendar@gmail.com'  # enter sender email-address
sender_password = 'Dat210calendar'  # enter password for sender email-address


# getData
#

def getData(data, request = None, ):
	functions = {
		'loadview': load_view,
		'nav': nav,
		'frontmenu': frontmenu,
		
		'login': login,
		'forgotpass': forgotpass,
		'newuser': newuser,
		'edituser': edit_user,
		'loggout': loggout,
		
		'calendar_list': calendar_list,
		'calendar_new': calendar_new,
		'calendar_edit': calendar_edit,
		'calendar_edit_form': calendar_edit_form,
		
		'event_list': event_list,
		'event_calendar': event_calendar,
		'event_calendar_list': event_calendar_list,
		'event_new': event_new,
		'event_edit': event_edit,
		'event_edit_form': event_edit_form,
		
		'task_new': task_new
	}
	
	if data in functions:
		return functions[data](request)


""" HOME """  # ----------------------------------------------


# LoadView
# Used to get Data for the home view
# Will return an object with an empty list if database call fails

def load_view(request):
	try:
		cal_db = []
		if request.get('calendars', 0):
			cal_db = request.get('calendars', 0)
		else:
			user_id = session['id']
			for cal_id, cal_name, cal_rights, cal_public in db.get_all_calendars_db(user_id):
				cal_db.append(cal_id)
		events = {'events': []}
		start = datetime.datetime.fromtimestamp(request.get('start', 0) / 1000.0).isoformat()
		end = datetime.datetime.fromtimestamp(request.get('end', 0) / 1000.0).isoformat()
		for cal_id in cal_db:
			events_db = back_event.search_events_usercalendar(user_id, cal_id, start, end)
			if events_db:
				for event in events_db['search_results']:
					start_event = time.mktime(event['start'].timetuple()) * 1000
					end_event = time.mktime(event['end'].timetuple()) * 1000
					event = {
						'start': start_event,
						'end': end_event,
						'name': event['name']
					}
					events['events'].append(event)
			else:
				continue
		return events
	except IOError as err:
		# Create Notification with error
		return {'events': []}


# Nav
# Used to get the format of the navigation bar when a user IS logged in

def nav(params):
	return {
		"items": {
			"Home": [0, "/home"],
			"Calendar": [1, {
				"New Calendar": [0, "calendar/new"],
				"My Calendars": [0, "calendar/list"],
			}],
			"Event": [1, {
				"New Event": [0, "event/new"],
				"My Events": [0, "event/list"]
			}],
			"Tasks": [1, {
				"New Task": [0, "task/new"],
				"My Tasks": [0, "task/list"]
			}],
			"Loggout": [0, "/loggedout"]
		}
	}


# Front Menu
# Used to get the format of the navigation bar when a user IS NOT logged in

def frontmenu(params):
	return {
		"items": {
			"Login": [0, "/login"],
			"New user": [0, "/newuser"],
			"Forgot password?": [0, "/forgotpass"]
		}
	}


""" USER """  # ----------------------------------------------


# Login
#

def login(request):
	username = request.get('username', 0)
	password = request.get('password', 0)
	login_db = back_user.login(username, password)
	if login_db['success']:
		session['id'] = login_db['user_id']
		session['username'] = username
		session['login'] = True
		resultat = {
			"success": login_db['success'],
			"data": {
				"username": username
			}
		}
	else:
		n.append(n.notification(1))
		resultat = {
			"notifications": n.flush(),
			"success": login_db['success'],
			"data": {
				"username": username
			}
		}
	return resultat


def newuser(request):
	email = request.get('form_new_email', 0)
	nickname = request.get('form_new_nick', 0)
	password = request.get('form_new_pass', 0)
	repeat_password = request.get('form_new_pass_repeat', 0)
	
	user = {}
	user["data"] = {
		"email": email,
		"nickname": nickname
	}
	if security.check_equal(password, repeat_password):
		result = back_user.register_user(email, password, nickname)
		user["success"] = result
		if not result:
			n.append(n.notification(3))
	else:
		n.append(n.notification(2))
		user["success"] = False
	user["notifications"] = n.flush()
	return user


def forgotpass(request):
	try:
		email = db.get_username_db(request.get('form_userid', 0))
		server = smtplib.SMTP_SSL('smtp.gmail.com', 465)  # Enter SSL configuration for domain
		server.ehlo()
		server.login(sender_user, sender_password)
		server.sendmail(sender_user, email, "TEST")
		server.close()
		# notification
		return {"success": True}
	except IOError as err:
		print(err)
		return


def edit_user(request):
	try:
		if request.get('password_repeat', 0) == request.get('password', 0):
			result = back_user.edit_user(request.get('username_old', 0), request.get('username', 0),
										 request.get('password', 0))
			user = {
				"success": result,
				"data": {
					"username": request.get('username', 0)
				}
			}
		else:
			user = {"success": False,
					"data": {"username": request.get('username', 0), "name": request.get('name', 0), }}
	except:
		user = {"success": False, "data": {"username": request.get('username', 0), "name": request.get('name', 0), }}
	return user


def loggout(params):
	try:
		username = session['username']
		user = {
			"success": back_user.logout(),
			"data": {
				'username': username
			}
		}
		return user
	except IOError as err:
		# notification
		return {"success": False}


""" CALENDAR """  # ----------------------------------------------


def calendar_list(request):
	try:
		cal_db = db.get_all_calendars_db(session['id'])
		calendars = []
		for cal_id, cal_name, cal_rights, cal_public in cal_db:
			calendar = {
				"id": cal_id,
				"name": cal_name,
				"rights": cal_rights,
				"public": cal_public
			}
			calendars.append(calendar)
		return calendars
	except IOError as err:
		# notification
		return [[]]


def calendar_new(request):
	try:
		name = request.get('form_calendar_name', 0)
		if request.get('form_calendar_public', 0) == 'public':
			public = True
		else:
			public = False
		db_calendar = back_event.add_new_calendar(session['id'], name, public)
		calendar = {
			"success": db_calendar['success'],
			"data": {
				"id": db_calendar['calendar_id'],
				"name": name,
				"public": public
			}
		}
	except IOError as err:
		# notification
		calendar = {"success": False}
	return calendar


def calendar_edit(params):
	result = db.get_calendar_db(session['id'], params['id'])
	calendar = {
		"success": True,
		"data": {
			"id": result[0],
			"name": result[1],
			"public": result[2]
		}
	}
	return calendar


def calendar_edit_form(request):
	id = request.get('form_calendar_id', 0)
	name = request.get('form_calendar_name', 0)
	if request('form_calendar_public', 0) == 'public':
		public = True
	else:
		public = False
	calendar = {
		"success": db.edit_calendar_db(id, name, public),
		"data": {
			"id": id,
			"name": name,
			"public": public
		}
	}
	if not calendar["success"]:
		n.append(n.notification(6))
	calendar["notifications"] = n.flush()
	return calendar


""" EVENT """  # ----------------------------------------------


def event_calendar(params):
	return {"calendar_id": params["args"].get("calendar_id", 0)}


def event_calendar_list(params):
	calendar_id = params["args"].get("calendar_id", 0)
	calendar_events = db.get_all_calendar_events_db(calendar_id)
	returner = []
	for event_id, _ in calendar_events:
		event = db.get_event_db(event_id)
		event = {
			"id": event_id,
			"calendar_id": calendar_id,
			"name": event[1],
			"start": str(event[3]),
			"end": str(event[4])
		}
		returner.append(event)
	if len(returner) == 0:
		n.append(n.notification(7))
	return returner


def event_list(request):
	try:
		cal_db = db.get_all_calendars_db(session['id'])
		resultat = []
		for cal_id, cal_name, cal_rights, cal_public in cal_db:
			events_db = db.get_all_calendar_events_db(cal_id)
			for event_id, cal_id in events_db:
				id, name, des, start, end = db.get_event_db(event_id)
				event = {
					'id': event_id,
					'name': name,
					'start': str(start),
					'end': str(end)
				}
				resultat.append(event)
		return resultat
	except IOError as err:
		print(err)
		# notifications
		return [{}]


def event_new(request):
	try:
		id = int(request.get('form_event_calendar', 0))
		if id > 0:
			start = datetime.datetime.strptime(request.get('form_event_start', 0), "%Y-%m-%dT%H:%M:%S.%fZ")
			end = datetime.datetime.strptime(request.get('form_event_end', 0), "%Y-%m-%dT%H:%M:%S.%fZ")
			result = back_event.add_new_event(id, request.get('form_event_name', 0), start.isoformat(), end.isoformat())
			
			event = {
				"success": result['success'],
				"data": {
					"id": result['event_id'],
					"calendar_id": id,
					"name": request.get('form_event_name', 0),
					"start": time.mktime(start.timetuple()) * 1000,
					"end": time.mktime(end.timetuple()) * 1000
				}
			}
			return event
		else:
			raise IOError('')
	except IOError as err:
		print(err)
		return {
			"success": False,
			"data": {
				"id": id,
				"name": request.get('form_event_name', 0),
				"start": request.get('form_event_start', 0),
				"end": request.get('form_event_end', 0)
			}
		}
	# notification


def event_edit_form(request):
	try:
		id = request.get('form_event_id', 0)
		calendar_id = request.form.get('form_event_calendar', 0)
		name = request.form.get('form_event_name', 0)
		start = request.form.get('form_event_start', 0)
		end = request.form.get('form_event_end', 0)
		
		event_form = {
			"success": db.edit_event_db(id, name, None, start, end, None, None),
			# event description mangler + intervall + terminate_date
			"data": {
				"id": id,
				"calendar_id": calendar_id,
				"calendars": getData("calendar_list"),
				"name": name,
				"start": start,
				"end": end
			}
		}
		return event_form
	except IOError as err:
		print(err)
		return {"success": False}


def event_edit(params):
	result = db.get_event_db(params["args"].get("event_id", 0))
	event = {
		"notifications": n.flush(),
		"success": True,
		"data": {
			"id": params["id"],
			"calendar_id": result[0],
			"calendars": getData("calendar_list"),
			"name": result[1],
			"start": str(result[2]),
			"end": str(result[3])
		}
	}
	return event


""" TASKS """  # ----------------------------------------------


def task_new(params):
	calendar_id = params.get('form_task_calendar', 0)
	name = params.get('form_task_name', 0)
	
	interval = {}
	temp = {}
	
	temp["interval_type"] = params.get('form_task_interval_type', 0)
	
	temp["interval_type_year"] = params.get('form_task_interval_type_year', 0)
	temp["interval_type_month"] = params.get('form_task_interval_type_month', 0)
	temp["interval_type_week"] = params.get('form_task_interval_type_week', 0)
	temp["interval_type_month_year"] = params.get('form_task_interval_type_month_year', 0)
	temp["interval_type_week_year"] = params.get('form_task_interval_type_week_year', 0)
	temp["interval_type_week_month"] = params.get('form_task_interval_type_week_month', 0)
	
	temp["interval_year"] = params.get('form_task_interval_year', 0)
	temp["interval_month"] = params.get('form_task_interval_month', 0)
	temp["interval_week"] = params.get('form_task_interval_week', 0)
	temp["interval_day"] = params.get('form_task_interval_day', 0)
	temp["interval_month_year"] = params.get('form_task_interval_month_year', 0)
	temp["interval_week_year"] = params.get('form_task_interval_week_year', 0)
	temp["interval_day_year"] = params.get('form_task_interval_day_year', 0)
	temp["interval_week_month"] = params.get('form_task_interval_week_month', 0)
	temp["interval_day_month"] = params.get('form_task_interval_day_month', 0)
	temp["interval_day_week"] = params.get('form_task_interval_day_week', 0)
	
	for element in temp:
		if temp[element] != 0 and temp[element] != "0":
			interval[element] = temp[element]
	
	todos = params.getlist('todos')
	user_id = session['id']
	
	# {'interval_type': 'year', 'interval_type_year': 'week_year', 'interval_week_year': '45', 'interval_year': '1',
	# 'interval_type_week_year': 'day_week', 'interval_day_week': 'Wednesday'}
	# name, description, interval, timestamp, calendarId, parentId
	
	# result = back_event.add_new_task(user_id, name, None, None, None, calendar_id)
	
	'''
	interval = {
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
	'''
	
	formattedInterval = "{weekInterval: {start: new Date(\"08 nov 2017\"), modulus: 2},dayNrInWeek: 2}"
	
	#formattedInterval = "{"
	
	#interval = "{}: {start: new Date({}), modulus: {}},"
	#if interval["interval_year"]:
	#	formattedInterval += interval.forma
	
	result = back_event.add_new_task(name, "Some placeholder description", formattedInterval, 0, calendar_id, None)
	
	#for todo in todos:
	#	back_event.add_new_task(todo, "Some placeholder description", formattedInterval, None, None, result["task_id"])
	
	returner = {
		"success": result["task_id"],
		"data": {
			"id": result["task_id"],
			"calendar_id": calendar_id,
			"name": name,
			"todos": todos,
			"interval": interval
		}
	}
	
	return returner
