from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from Flask app deployed via Jenkins and Docker Registry!"


@app.route('/about')
def about():
    return "Python flask app"

@app.route('/page/<name>')
def page(name):
    return f" Hello {name}"

app.run(host="0.0.0.0", port=6000)
