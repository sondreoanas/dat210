import unittest
from back import *


# Here's our "unit".
def IsOdd(n):
    return n % 2 == 1


# Here's our "unit tests".
class LoginTest(unittest.TestCase):

    def test_valid_login(self):
        with app.app_context():
            self.assertEqual(valid_login("ola@nordmann.no", "Password123"), True)

    def test_invalid_login1(self):
        with app.app_context():
            self.assertEqual(valid_login("ola@nordmann.no", "Password124"), False)

    def test_invalid_login2(self):
        with app.app_context():
            self.assertEqual(valid_login("ola@nordmann.mo", "Password123"), False)

    def test_invalid_login3(self):
        with app.app_context():
            self.assertEqual(valid_login("ola@nordmann.no", " "), False)

    def test_invalid_login4(self):
        with app.app_context():
            self.assertEqual(valid_login("",""), False)

    def test_existing_user(self):
        with app.app_context():
            self.assertEqual(existing_user("ola@nordmann.no"), True)

    def test_unregistered_user(self):
        with app.app_context():
            self.assertEqual(existing_user("ola@nordmann.p"), False)

    def test_register_user_fail(self):
        with app.app_context():
            self.assertEqual(valid_register_user("ola@nordmann.no", "passord", "Ole"), False)

    def test_register_user_success(self):
        with app.app_context():
            self.assertEqual(valid_register_user("ola@nordmann.mo", "passord", "Ole"), True)



def main():
    unittest.main()

if __name__ == '__main__':
    main()
