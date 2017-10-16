import unittest
from back_user import *
from logged_in_user import *

username = "ola@nordmann.no"
password = "Password123"
name = "Ola Nordmann"
userid = 1201

def login_testuser():
    login(username, password)


class LoginTest(unittest.TestCase):

    def test_0_valid_login(self):
        with app.app_context():
            self.assertEqual(login("ola@nordmann.no", "Password123"), True)

    def test_1_invalid_login1(self):
        with app.app_context():
            self.assertEqual(login("ola@nordmann.no", "Password124"), False)

    def test_2_invalid_login2(self):
        with app.app_context():
            self.assertEqual(login("ola@nordmann.mo", "Password123"), False)

    def test_3_invalid_login3(self):
        with app.app_context():
            self.assertEqual(login("ola@nordmann.no", " "), False)

    def test_4_invalid_login4(self):
        with app.app_context():
            self.assertEqual(login("", ""), False)

    def test_5_existing_user(self):
        with app.app_context():
            self.assertEqual(user_exist("ola@nordmann.no"), True)

    def test_6_unregistered_user(self):
        with app.app_context():
            self.assertEqual(user_exist("ola@nordmann.p"), False)

    def test_7_register_user_fail(self):
        with app.app_context():
            self.assertEqual(register_user("ola@nordmann.no", "passord", "Ole"), False)

    def test_8_register_user_success(self):
        with app.app_context():
            self.assertEqual(register_user("ola@nordmann.mo", "passord", "Ole"), True)


class EmailTest(unittest.TestCase):
    def test_valid_email(self):
        self.assertEqual(valid_username("test@test.no"), True)
    def test_invalid_email1(self):
        self.assertEqual(valid_username("te#st@test.no"), False)
    def test_invalid_email2(self):
        self.assertEqual(valid_username("te st@test.no"), False)
    def test_invalid_email3(self):
        self.assertEqual(valid_username("test@te@st.no"), False)
    def test_invalid_email4(self):
        self.assertEqual(valid_username("tes\"t@test.no"), False)
    def test_invalid_email5(self):
        self.assertEqual(valid_username("tes*t@test.no"), False)
    def test_invalid_email6(self):
        self.assertEqual(valid_username("test@te£st.no"), False)
    def test_invalid_email7(self):
        self.assertEqual(valid_username("test@te{st.no"), False)


class LoggedInTest(unittest.TestCase):
    def test_00_get_username(self):
        with app.app_context():
            self.assertEqual(the_user.get_username(), False)

    def test_01_get_username(self):
        with app.app_context():
            login_testuser()
            self.assertEqual(the_user.get_username(), username)

    def test_50_get_username(self):
        with app.app_context():
            logout()
            self.assertEqual(the_user.get_username(), False)

    def test_02_get_name(self):
        with app.app_context():
            self.assertEqual(the_user.get_name(), name)

    def test_99_get_name(self):
        with app.app_context():
            self.assertEqual(the_user.get_name(), False)
    
    def test_03_get_user_id(self):
        with app.app_context():
            self.assertEqual(the_user.get_userid(), userid)
    
    def test_98_get_user_id(self):
        with app.app_context():
            self.assertEqual(the_user.get_userid(), False)


def main():
    unittest.main()

if __name__ == '__main__':
    main()
