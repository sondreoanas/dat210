"""
    Security
    This file contains the code for securing the data
    that is stored

    Sist oppdatert: Sondre 04.10.2017

"""

import os
from werkzeug.security import pbkdf2_hex
import back


# Password Check:
# Checks if a password is valid

def password_check(username,user_password):
    salt = 0 #from database?
    client_password = pbkdf2_hex(user_password, salt, iterations=50000, keylen=None, hashfunc=None) # Default SHA-256
    return back.valid_login(username,user_password)

# Create Password:
# Creates a password using a unique salt and a hashing algorithm

def create_password(username,user_password, name):
    salt = os.urandom(10)
    client_password = pbkdf2_hex(user_password, salt, iterations=50000, keylen=None, hashfunc=None)
    return valid_register_user(username,client_password,name)



