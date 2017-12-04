
import sys

def getUsernamePassword():
	usernamePath = "../../username.txt"
	passwordPath = "../../password.txt"
	# create files if they don't exist
	open(usernamePath, "a+").close()
	open(passwordPath, "a+").close()
	# read files
	with open(passwordPath, "r") as f:
		password = f.read()
	with open(usernamePath, "r") as f:
		username = f.read()
	# check if no responce
	if password == '' or username == '':
		if password == '':
			print("No password found.")
		if username == '':
			print("No username found.")
		username = input("Type in your username.\n(End with enter. If enter fails, restart without debug mode): ")
		with open(usernamePath, "w+") as f:
			f.write(username)
		password = input("Type in your password.\n(End with enter. If enter fails, restart without debug mode): ")
		with open(passwordPath, "w+") as f:
			f.write(password)
		print("\nPassword and username saved!\nOne level above your 'dat210' folder there is "
			  "a username and password file where\nyou can change your username and password.\n"
			  "You can now start the server again")
		sys.exit(0)
	return (username, password)
