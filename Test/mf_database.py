'''
	mf_app.py
	version			: 0.0.0
	last updated	: 18.11.2017
	name			:
	description		:
		What does this do?
			This communicates with the database. mf_app will ask for data from the database, and theese functions will
			provide it.
		How to use it?
			mf_app will make calls to theese functions to get data from the database.
'''
from flask import g, session
import mysql.connector
import time
import mf_passwordTester
from mf_app import isLoggedIn, printError

def createUser(email, hashedPassword, salt, nickname):
	database = getDatabase()
	cursor = getCursor()
	try:
		sql2 = "INSERT INTO user " \
				"(Email, Password, Salt, Name) " \
				"VALUES (%s, %s, %s, %s) "
		cursor.execute(sql2, (email, hashedPassword, salt, nickname))
		database.commit()
		userId = cursor.lastrowid
		return userId
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def checkEmailInUse(email):
	cursor = getCursor()
	try:
		sql = "SELECT Deleted " \
			"FROM user " \
			"WHERE Email = %s "
		cursor.execute(sql, (email,))
		result = cursor.fetchall()
		for r in result:
			if r[0] == 0: # user with same username exists that is not deleted
				return False
		return True
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def getUserIdPassword(email):
	# If the user exists, (userId, hashedPasswordFromDatabase) is returned,
	# if the username does not exist, False is returned,
	# if an error occurs, -1 is returned
	cursor = getCursor()
	try:
		sql = "SELECT Password, UserId " \
			"FROM user " \
			"WHERE Email = %s "
		cursor.execute(sql, (email,))
		result = cursor.fetchall()
		if len(result) != 1:
			return -1
		hashedPasswordFromDatabase = result[0][0]
		userId = result[0][1]
		return (userId, hashedPasswordFromDatabase)
	except mysql.connector.Error as err:
		printError(err)
		return -1
	except BaseException as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def resetTask(taskId):
	# Will reset isDone and timestamp of task with id taskId and all children of that task
	database = getDatabase()
	cursor = getCursor()
	# # get task hierarchy
	ids = [taskId]
	try:
		for parentId in ids:
			sql = "select TaskId from task where parentId = %s;"
			cursor.execute(sql, (parentId,))
			result = cursor.fetchall()
			ids += [t[0] for t in result]
		# # update timestamp and reset IsDone
		timestamp = int(time.time() * 1000)
		for toBeResetId in ids:
			sql = "update annualcycle.task set IsDone = 0 where TaskId=%s;"
			cursor.execute(sql, (toBeResetId,))
			sql = "update annualcycle.task set timestamp = {} where TaskId=%s;"
			sql = sql.format(timestamp)
			cursor.execute(sql, (toBeResetId,))
	except mysql.connector.Error as err:
		printError(err)
		return -1
	except BaseException as err:
		printError(err)
		return -1
	finally:
		database.commit()
		cursor.close()
	return True

def setTaskDone(taskId):
	database = getDatabase()
	cursor = getCursor()
	try:
		sql = "update annualcycle.task set IsDone = 1 where TaskId=%s;"
		cursor.execute(sql, (taskId,))
		database.commit()
	except mysql.connector.Error as err:
		printError(err)
		return -1
	except BaseException as err:
		printError(err)
		return -1
	finally:
		cursor.close()
	
	return True

def getTasksOfUser(userId):
	ids = getCalendarIdsOfUser(userId)
	
	if ids == -1:
		return -1
	
	# load root tasks
	attributes = "TaskId, Name, task.Interval, Deleted, IsDone, ParentId, CalendarId, Timestamp"
	result = []
	cursor = getCursor()
	try:
		for calendarId in ids:
			sql = "select {} from task where calendarId = %s;"
			sql = sql.format(attributes)
			cursor.execute(sql, (calendarId,))
			result += cursor.fetchall()
		newList = []
		for r in result:
			newList.append({"id": r[0], "name": r[1], "interval": r[2], "deleted": r[3],\
						  "isDone": r[4], "parentId": r[5], "calendarId": r[6], "timestamp": r[7]})
	except mysql.connector.Error as err:
		printError(err)
		cursor.close()
		return -1
	except BaseException as err:
		printError(err)
		cursor.close()
		return -1
	
	# load children of root tasks
	tasks = newList[:]
	while True:
		temp = []
		for t in newList:
			sql = "select {} from task where parentId = {};"
			sql = sql.format(attributes, t["id"])
			cursor.execute(sql)
			result = cursor.fetchall()
			for r in result:
				temp.append({"id": r[0], "name": r[1], "interval": r[2], "deleted": r[3],\
					"isDone": r[4], "parentId": r[5], "calendarId": t["calendarId"], "timestamp": r[7]})
		if len(temp) == 0:
			break
		tasks += temp
		newList = temp
	cursor.close()
	
	return tasks

def editCalendar(newCalendarName, newIsPublic, calendarId, userId):
	database = getDatabase()
	cursor = getCursor()
	try:
		sql = "UPDATE calendar " \
			"SET Name = %s, Public = %s " \
			"WHERE CalendarId = %s AND CalendarId = (SELECT CalendarId " \
			"FROM usercalendars " \
			"WHERE CalendarId = %s AND UserId = %s AND Adminlevel >= 2) "
		cursor.execute(sql, (newCalendarName, newIsPublic, calendarId, calendarId, userId))
		database.commit()
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()
	return True

def editEvent(eventId, userId, newName, newDescription, newStart, newEnd, newInterval, newCalendarId):
	database = getDatabase()
	cursor = getCursor()
	try:
		sql = "UPDATE eventn " \
			"join eventcalendar on eventcalendar.EventId = eventn.EventId " \
			"join usercalendars on usercalendars.CalendarId = eventcalendar.CalendarId " \
			"join `user` on `user`.UserId = usercalendars.UserId " \
			"Set eventn.Name = %s, eventn.Description = %s, eventn.Start = %s, eventn.End = %s, eventn.`Interval` = %s," \
				"eventcalendar.CalendarId = %s " \
			"where `user`.UserId = %s and usercalendars.Adminlevel >= 2 " \
				"and eventn.EventId = %s;"
		cursor.execute(sql, (newName, newDescription, newStart, newEnd, newInterval, newCalendarId, userId, eventId))
		database.commit()
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()
	return True

def getEventsOfCalenderOfUser(userId, calendarId):
	cursor = getCursor()
	try:
		sql = "select eventn.EventId, eventn.`Name`, eventn.`Start`, eventn.`End` " \
			"from `user` " \
			"join usercalendars on usercalendars.UserId = `user`.UserId " \
			"join eventcalendar on eventcalendar.CalendarId = usercalendars.CalendarId " \
			"join eventn on eventn.EventId = eventcalendar.EventId " \
			"where `user`.UserId = %s and eventcalendar.CalendarId = %s;"
		cursor.execute(sql, (userId, calendarId,))
		result = cursor.fetchall()
		events = [{
				"id": eventTuple[0],
				"name": eventTuple[1],
				"start": eventTuple[2],
				"end": eventTuple[3]
			} for eventTuple in result]
		return events
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def getEvent(eventId):
	if not isLoggedIn():
		return -1
	userId = session["id"]
	
	# return list of event objects. "start" and "end" is optional
	cursor = getCursor()
	try:
		sql = "select eventn.EventId, eventn.`Name`, eventn.`Start`, eventn.`End`, eventcalendar.CalendarId " \
			"from `user` " \
			"join usercalendars on usercalendars.UserId = `user`.UserId " \
			"join eventcalendar on eventcalendar.CalendarId = usercalendars.CalendarId " \
			"join eventn on eventn.EventId = eventcalendar.EventId " \
			"where `user`.UserId = %s and eventn.EventId = %s"
		cursor.execute(sql, (userId, eventId,))
		result = cursor.fetchall()
		if len(result) != 1:
			return -1
		event = {
				"id": result[0][0],
				"name": result[0][1],
				"start": result[0][2],
				"end": result[0][3],
				"calendarId": result[0][4],
			}
		return event
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def getAllEventsOfUser(userId, start, end):
	# return list of event objects. "start" and "end" is optional
	cursor = getCursor()
	try:
		sql = "select eventn.EventId, eventn.`Name`, eventn.`Start`, eventn.`End` " \
			"from `user` " \
			"join usercalendars on usercalendars.UserId = `user`.UserId " \
			"join eventcalendar on eventcalendar.CalendarId = usercalendars.CalendarId " \
			"join eventn on eventn.EventId = eventcalendar.EventId " \
			"where `user`.UserId = %s;"
		if start is not None and end is not None:
			sql = sql[:-1] + " and eventn.Start < %s AND eventn.End > %s;"
			cursor.execute(sql, (userId, end, start))
		else:
			cursor.execute(sql, (userId,))
		result = cursor.fetchall()
		events = [{
				"id": eventTuple[0],
				"name": eventTuple[1],
				"start": eventTuple[2],
				"end": eventTuple[3]
			} for eventTuple in result]
		return events
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def createNewTask(userId, name, description, interval, timestamp, calendarId, parentId):
	database = getDatabase()
	cursor = getCursor()
	try:
		sql = "INSERT INTO task " \
			"(Name, Description, `Interval`, Timestamp, CalendarId, ParentId) " \
			"VALUES (%s, %s, %s, %s, %s, %s);"
		cursor.execute(sql, (name, description, interval, timestamp, calendarId, parentId))
		taskId = cursor.lastrowid
		database.commit()
		return taskId
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def createNewEvent(name, startTime, endTime, calendarId): #TODO: remove ToDatabase from name, also add->create
	# TODO: security, does this user have access to this calendar?
	# startTime and endTime is given in iso format
	database = getDatabase()
	cursor = getCursor()
	
	# add event in database
	try:
		sql = "INSERT INTO eventn " \
			"(Name, Start, End) " \
			"VALUES (%s, %s, %s) "
		cursor.execute(sql, (name, startTime, endTime))
		eventId = cursor.lastrowid
	except mysql.connector.Error as err:
		printError(err)
		cursor.close()
		return -1
	except BaseException as err:
		printError(err)
		cursor.close()
		return -1
	
	# add calendar event connection
	try:
		sql = "INSERT INTO eventcalendar " \
			"(EventId, CalendarId) " \
			"VALUES (%s, %s) "
		cursor.execute(sql, (eventId, calendarId))
		database.commit()
		return eventId
	except mysql.connector.Error as err:
		printError(err)
		return -1
	except BaseException as err:
		printError(err)
		return -1
	finally:
		cursor.close()
	return True

def createNewCalendar(userId, calendarName, isPublic):
	database = getDatabase()
	cursor = getCursor()
	try:
		sql = "INSERT INTO calendar " \
			"(Name, Public) " \
			"VALUES (%s, %s) "
		cursor.execute(sql, (calendarName, isPublic))
		calendarId = cursor.lastrowid
	except mysql.connector.Error as err:
		printError(err)
		cursor.close()
		return -1
	
	try:
		sql = "INSERT INTO usercalendars " \
			"(UserId, CalendarId, Adminlevel, Notifications) " \
			"VALUES (%s, %s, %s, %s) "
		cursor.execute(sql, (userId, calendarId, 3, 0))
	except mysql.connector.Error as err:
		printError(err)
		return -1
	finally:
		cursor.close()
	
	database.commit()
	
	return calendarId

def getCalendarIdsOfUser(userId):
	calendars = getAllCalendarsOfUser(userId)
	if calendars == -1:
		return -1
	return [c["id"] for c in calendars]

def getAllCalendarsOfUser(userId): # TODO: rename to getAllCalendarsOfUser
	cursor = getCursor()
	try:
		sql = "select calendar.CalendarId, calendar.Name, usercalendars.Adminlevel, calendar.Public " \
			  "from usercalendars join calendar " \
		  "on UserId = %s and usercalendars.CalendarId = calendar.CalendarId;"
		cursor.execute(sql, (userId,))
		result = cursor.fetchall()
		result = [{
			"id": calendarTuple[0],
			"name": calendarTuple[1],
			"adminLevel": calendarTuple[2],
			"public": calendarTuple[3]
				  } for calendarTuple in result]
		return result
	except mysql.connector.Error as err:
		printError(err)
		return -1
	except BaseException as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def getCalendarOfUser(userId, calendarId):
	cursor = getCursor()
	try:
		sql = "select calendar.CalendarId, calendar.Name, usercalendars.Adminlevel, calendar.Public " \
			  "from usercalendars join calendar " \
		  "on UserId = %s and usercalendars.CalendarId = calendar.CalendarId and calendar.CalendarId = %s;"
		cursor.execute(sql, (userId, calendarId,))
		resultTuple = cursor.fetchall()
		if len(resultTuple) != 1:
			return -1
		result = {
			"id": resultTuple[0][0],
			"name": resultTuple[0][1],
			"adminLevel": resultTuple[0][2],
			"public": resultTuple[0][3]
		}
		return result
	except mysql.connector.Error as err:
		printError(err)
		return -1
	except BaseException as err:
		printError(err)
		return -1
	finally:
		cursor.close()

def getCursor():
	return getDatabase().cursor()

def getDatabase():
	if not hasattr(g, "database_"):
		(loadedUsername, loadedPassword) = mf_passwordTester.getUsernamePassword()
		g.database_ = mysql.connector.connect(
			user=loadedUsername, password=loadedPassword, host="127.0.0.1", database="annualcycle"
		)
	return g.database_






