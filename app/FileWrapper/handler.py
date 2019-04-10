import sys
import os
import logging
logging.info(sys.path)
logging.info(os.getcwd())

def handler(file):
    logging.info('Python Blob trigger function processed %s', file.name)
    print("This is a test")
    return main(file)


def main(file):
    print("Running the Data Science Algorithm")
    print(file)
    lines = file.readLines()
    for line in lines:
        line += " wow"
    print("Completed the Data Science Algorithm")
    return lines

if __name__ == "__main__":
    print("Called as standalone script")
    handler(file)
