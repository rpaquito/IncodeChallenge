import pymysql
from flask import Flask
import os
import sys


app = Flask(__name__)

@app.route('/')
def home():
    return "Backend Works!!!"


@app.route('/api/name', methods=['GET'])
def get_names():
    return "Get names Works!!!"

@app.route('/api/city', methods=['GET'])
def get_city():
    return "Get city Works!!!"

@app.route('/api/env', methods=['GET'])
def get_env():
    if os.getenv('db_username') is not None:
        db_user = os.environ['db_username']
    else:
        db_user = "Empty User"

    if os.getenv('db_password') is not None:
        db_pass = os.environ['db_password']
    else:
        db_pass = "Empty Pass"

    if os.getenv('db_endpoint') is not None:
        db_ep = os.environ['db_endpoint']
    else:
        db_ep = "Empty Endpoint"

    returnStr = "Username: " +  db_user + "  Password: " + db_pass + "  Endpoint: " + db_ep

    return returnStr

@app.route('/api/testdb', methods=['GET'])
def get_testdb():
    if os.getenv('db_username') is not None:
        db_user = os.environ['db_username']
    else:
        db_user = "Empty User"

    if os.getenv('db_password') is not None:
        db_pass = os.environ['db_password']
    else:
        db_pass = "Empty Pass"

    if os.getenv('db_endpoint') is not None:
        db_ep = os.environ['db_endpoint']
    else:
        db_ep = "Empty Endpoint"

    returnTxt = "Not able to connect"

    try:
        print("Connecting to "+db_ep)
        #db = pymysql.connect(db_ep,db_user,db_pass)
        db = pymysql.connect(host=db_ep,
                             user=db_user,
                             password=db_pass,
                             database='mysqldb',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)
        print("Connection successful to "+db_ep)
        returnTxt = "Connected"
    except Exception as e:
        print("Connection unsuccessful due to "+str(e))
        print("Connection unsuccessful due to "+str(e), file = sys.stderr)
        returnTxt+=" "+str(e)

    return returnTxt
