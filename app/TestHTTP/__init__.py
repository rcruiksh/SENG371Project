import platform
print(platform.python_version())

def main(req):
    user = req.params.get('user')
    return 'Hello, ' + user
