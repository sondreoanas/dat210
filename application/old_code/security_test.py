import os
import security

class user(object):
    def __init__(self,username,password):
        user = security.create_password(password)
        self.username = username
        self.password = user[0]
        self.salt = user[1]

    def get_info(self):
        return self.password

    def correct_password(self, password):
        if security.check_password(password,self.password,self.salt): return print(True)
        else: return print(False)

USER_1  = user('Tom','passord')
USER_2 = user('mikkel', 'passord')

USER_1.get_info()
USER_2.get_info()

USER_1.correct_password('passor')
USER_1.correct_password('passord')

print(security.check_input("hello"""))











