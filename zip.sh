cd venv/lib/python3.7/site-packages/
zip -r9u ../../../../app.zip .

cd ../../../../
cd app/
zip -gu ../app.zip function.py
