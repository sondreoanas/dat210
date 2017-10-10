import os
import security

class user(object):
    def __init__(self,username,password):
        self.username = username
        self.password = security.create_password_test(password)
        self.salt = os.urandom(10)

    def get_info(self):
        print(self.username + ' ' + self.password)

    def correct_password(self, password):
        security.password_check_test(self.password,password)

USER_1  = user('Tom','passord')
USER_2 = user('mikkel', 'passord')

USER_1.get_info()










