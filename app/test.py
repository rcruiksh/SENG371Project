import unittest
import function

class DSATestMethods(unittest.TestCase):

    def test_data_modification(self):
        original = ['test string']
        expected = ['test string ... every single line']
        self.assertEqual(expected, function.data_modification(original))

if __name__ == '__main__':
    unittest.main()
