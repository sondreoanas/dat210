"""
    Security
    This file contains the code for securing the data
    that is stored

    Sist oppdatert: Sondre 04.10.2017

"""

import os
import werkzeug.security as w
import re
import back_db as db


# Password Check:
# Checks if a password is valid

def check_password(user_password, client_password, salt):
    user_password = w.pbkdf2_hex(user_password,salt,iterations=50000, keylen=None, hashfunc=None) # Default hashfunc SHA-256
    if user_password == client_password: return True
    else: return False

# Create Password:
# Creates a password using a unique salt and a hashing algorithm

def create_password(user_password):
    # Oppdatering: hvis ikke oppdatert i databasen
    #salt = os.urandom(10)
    salt = os.urandom(10).hex()
    client_password = w.pbkdf2_hex(user_password, salt, iterations=50000, keylen=None, hashfunc=None)
    return [client_password, salt]

# Email Check:
# Check if email is in the email format

def check_email(email):
    EMAIL_REGEX = re.compile(r"[^@]+@[^@]+\.[^@]+")
    # Regex source: http://stackoverflow.com/questions/8022530/python-check-for-valid-email-address
    if EMAIL_REGEX.match(email): return True
    else: return False

def create_pass_link(email):
    id = os.urandom(10).hex()
    start_link = "http://127.0.0.1:5000/reset_pass/" + id
    user_id = db.get_userid_db(email)[0]
    db.insert_forgot_pass(id, 1,user_id)
    return start_link


# Inputtype Check:
# Checks if the input type is valid and not a script

INJECTIONS = ['<script>']

def check_input(input):
    # Injection check:
    for injection in INJECTIONS:
        if input in injection: return NameError
        return input.strip('"\'')





