rm -rf app.zip
cd app
find . -name __pycache__ -type d -exec rm -rf {} \;
zip -r ../app.zip *
