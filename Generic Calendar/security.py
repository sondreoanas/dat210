"""
    Security
    This file contains the code for securing the data
    that is stored

    Sist oppdatert: Sondre 04.10.2017

"""

import os
from werkzeug.security import pbkdf2_hex
import re

import back


# Password Check:
# Checks if a password is valid

def password_check(username,user_password,salt):
    #salt = from database
    client_password = pbkdf2_hex(user_password, salt, iterations=50000, keylen=None, hashfunc=None) # Default hashfunc SHA-256
    return back.valid_login(username,client_password)

# Create Password:
# Creates a password using a unique salt and a hashing algorithm

def create_password(username,user_password, name):
    salt = os.urandom(10)
    client_password = pbkdf2_hex(user_password, salt, iterations=50000, keylen=None, hashfunc=None)
    return back.valid_register_user(username,client_password,name)

def password_check_test(user_password, client_password, salt):
    #salt = from database
    if client_password == pbkdf2_hex(user_password, salt, iterations=50000, keylen=None, hashfunc=None): # Default hashfunc SHA-256
        return True
    else: return False


def create_password_test(user_password):
    salt = os.urandom(10)
    client_password = pbkdf2_hex(user_password, salt, iterations=50000, keylen=None, hashfunc=None)
    return client_password


# Email Check:
# Check if email is in the email format

def check_email(email):
    EMAIL_REGEX = re.compile(r"[^@]+@[^@]+\.[^@]+")
    if EMAIL_REGEX.match(email): return True
    else: return False



# Inputtype Check:
# Checks if the input type is valid and not a script

INJECTIONS = ['<script>']

def check_input(input):
    # Injection check:
    for injection in INJECTIONS:
        if input in injection: return False
        else: return True



