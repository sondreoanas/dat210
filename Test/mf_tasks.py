'''
	mf_tasks.js
	version			: 0.1.1
	last updated	: 14.11.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This manages task related communication between the client and the database
		How to use it?
			...
'''

from flask import Blueprint, request, session
import back_db
import back_event
import json
import datetime
import time

mf_page = Blueprint('mf_page', __name__, template_folder='templates')

@mf_page.route("/getTasks", methods=["POST"])
def getTasks():
	if not "id" in session:
		return json.dumps({}) # TODO: make error handeling
	userId = session["id"]
	
	if userId == -1:
		return json.dumps({}) # TODO: make error handeling
	
	db = back_db.get_db()
	cur = db.cursor()
	
	# get calendar ids TODO: abstact this
	sql = "select calendar.CalendarId from usercalendars join calendar " \
		  "on UserId = {} and usercalendars.CalendarId = calendar.CalendarId;"
	sql = sql.format(userId)
	cur.execute(sql)
	ids = [idTuple[0] for idTuple in cur.fetchall()]
	
	# load root tasks
	attributes = "TaskId, Name, task.Interval, Deleted, IsDone, ParentId, CalendarId, Timestamp"
	result = []
	for calendarId in ids:
		sql = "select {} from task where calendarId = %s;"
		sql = sql.format(attributes)
		cur.execute(sql, (calendarId,))
		result += cur.fetchall()
	newList = []
	for r in result:
		newList.append({"id": r[0], "name": r[1], "interval": r[2], "deleted": r[3],\
					  "isDone": r[4], "parentId": r[5], "calendarId": r[6], "timestamp": r[7]})
	
	# load children of root tasks
	tasks = newList[:]
	while True:
		temp = []
		for t in newList:
			sql = "select {} from task where parentId = {};"
			sql = sql.format(attributes, t["id"])
			cur.execute(sql)
			result = cur.fetchall()
			for r in result:
				temp.append({"id": r[0], "name": r[1], "interval": r[2], "deleted": r[3],\
					"isDone": r[4], "parentId": r[5], "calendarId": t["calendarId"], "timestamp": r[7]})
		if len(temp) == 0:
			break
		tasks += temp
		newList = temp
	cur.close()
	return json.dumps({"tasks": tasks})

@mf_page.route("/setTaskDone", methods=["POST"])
def setTaskDone():
	taskId = request.get_json().get("taskId", -1)
	
	if taskId == -1:
		return "" # TODO: make error handeling
	
	db = back_db.get_db()
	cur = db.cursor()
	
	sql = "update annualcycle.task set IsDone = 1 where TaskId=%s;"
	cur.execute(sql, (taskId,))
	db.commit()
	
	cur.close()
	
	return ""

@mf_page.route("/addNewEvent", methods=["POST"])
def addNewEvent():
	calendarId = request.get_json().get("calendarId", -1)
	eventName = request.get_json().get("eventName", -1)
	start = request.get_json().get("start", -1)
	end = request.get_json().get("end", -1)
	
	start = datetime.datetime.fromtimestamp(int(start / 1000)).strftime('%Y-%m-%d %H:%M:%S')
	end = datetime.datetime.fromtimestamp(int(end / 1000)).strftime('%Y-%m-%d %H:%M:%S')
	
	if calendarId == -1 or eventName == -1 or start == -1 or end == -1:
		return json.dumps({"isSuccess": False})
	
	result = back_event.add_new_event(calendarId, eventName, start, end)
	if result["success"]:
		return json.dumps({"isSuccess": True})
	
	return json.dumps({"isSuccess": False})

@mf_page.route("/resetTasks", methods=["POST"])
def resetTasks():
	taskId = request.get_json().get("taskId", -1)
	
	if taskId == -1:
		return "" # TODO: make error handeling
	
	db = back_db.get_db()
	cur = db.cursor()
	
	ids = [taskId]
	for parentId in ids:
		sql = "select TaskId from task where parentId = %s;"
		cur.execute(sql, (parentId,))
		result = cur.fetchall()
		ids += [t[0] for t in result]
	
	timestamp = int(time.time() * 1000)
	for toBeResetId in ids:
		sql = "update annualcycle.task set IsDone = 0 where TaskId=%s;"
		cur.execute(sql, (toBeResetId,))
		sql = "update annualcycle.task set timestamp = {} where TaskId=%s;"
		sql = sql.format(timestamp)
		cur.execute(sql, (toBeResetId,))
	
	db.commit()
	cur.close()
	
	return ""












