import unittest
import function

# Here we have defined a super simple test class for writing test functions

class DSATestMethods(unittest.TestCase):

    def test_data_modification(self):
        original = ['test string']
        expected = ['test string ... every single line']
        self.assertEqual(expected, function.data_modification(original))

if __name__ == '__main__':
    unittest.main()
