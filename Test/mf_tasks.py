'''
	mf_tasks.js
	version			: 0.0.0
	last updated	: 31.10.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This manages task related communication between the client and the database
		How to use it?
			...
'''

from flask import Blueprint, request
import back_db
import json

mf_page = Blueprint('mf_page', __name__, template_folder='templates')

@mf_page.route("/getTasks", methods=["POST"])
def getTasks():
	json.dumps({"tasks": []})
	calId = request.get_json().get("calId", -1)
	if calId == -1:
		return json.dumps({})
	db = back_db.get_db()
	cur = db.cursor()
	# SOME LOGIN TEST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	attributes = "TaskId, Name, task.Interval, Deleted, IsDone, ParentId, CalendarId, Timestamp"
	sql = "select {} from task where calendarId = {};"
	sql = sql.format(attributes, calId)
	cur.execute(sql)
	result = cur.fetchall()
	newList = []
	for r in result:
		newList.append({"id": r[0], "name": r[1], "interval": r[2], "deleted": r[3],\
					  "isDone": r[4], "parentId": r[5], "calendarId": r[6], "timestamp": r[7]})
	tasks = newList[:]
	while True:
		temp = []
		for t in newList:
			if t["isDone"] == 0:
				continue
			sql = "select {} from task where parentId = {};"
			sql = sql.format(attributes, t["id"])
			cur.execute(sql)
			result = cur.fetchall()
			for r in result:
				temp.append({"id": r[0], "name": r[1], "interval": r[2], "deleted": r[3],\
					"isDone": r[4], "parentId": r[5], "calendarId": r[6], "timestamp": r[7]})
		if len(temp) == 0:
			break
		tasks += temp
		newList = temp
	cur.close()
	return json.dumps({"tasks": [t for t in tasks if t["isDone"] == 0]})



