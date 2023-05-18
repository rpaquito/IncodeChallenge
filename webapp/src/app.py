from flask import Flask, render_template, request, url_for, flash, redirect
import os
import requests

app = Flask(__name__)

@app.route("/hello")
def hello():
    return "Hello World!"


@app.route("/")
def index():
    links = {"http://"+get_backend_url()+"/api/name" : 'Get Names', "http://"+get_backend_url()+"/api/city": 'Get Cities'}
    returnVal = ""

    for link in links:
            returnVal+= "<a href=\""+link+"\"<h2>"+links[link]+"</h2></a></hr><br>"

    return returnVal  

@app.route("/names")
def names():
    api_url = "http://"+get_backend_url()+"/api/name"    
    response = requests.get(api_url, timeout=10)
 
    return response.content

@app.route("/cities")
def cities():
    api_url = "http://"+get_backend_url()+"/api/city"    
    response = requests.get(api_url, timeout=10)
 
    return response.content

@app.route("/env")
def env():
    api_url = "http://"+get_backend_url()+"/api/env"
    response = requests.get(api_url, timeout=10)
 
    return response.content

@app.route("/testdb")
def testdb():
    api_url = "http://"+get_backend_url()+"/api/testdb"
    response = requests.get(api_url, timeout=10)
 
    return response.content    


def get_backend_url():
    if os.getenv('backendDns') is not None:
        backendURL = os.environ['backendDns']
    else:
        backendURL = "localhost:8081"

    return backendURL