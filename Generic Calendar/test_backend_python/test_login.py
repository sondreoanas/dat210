from back import valid_login
import unittest


# Here's our "unit".
def IsOdd(n):
    return n % 2 == 1


# Here's our "unit tests".
class IsOddTests(unittest.TestCase):

    def testOne(self):
        self.failUnless(IsOdd(1))

    def testTwo(self):
        self.failIf(IsOdd(2))

    def test_valid_login(self):
        self.assertEqual(valid_login("ola@nordmann.no", "Password123"), True)


def main():
    unittest.main()

if __name__ == '__main__':
    main()
