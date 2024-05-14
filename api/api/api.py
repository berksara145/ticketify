from flask import Flask, request, jsonify
import re
import os
from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
from flask_cors import CORS

#https://www.youtube.com/watch?v=5uiHHX4Sxw8

app = Flask(__name__)
CORS(app) 
app.secret_key = 'abcdefgh'

app.config['MYSQL_HOST'] = 'db'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password1212'
app.config['MYSQL_DB'] = 'cs353dbproject'

mysql = MySQL(app)


#@app.route('/')
@app.route('/login', methods=['GET','POST'])
def login():
    # Get login request data from the request body
    data = request.json
    email = data.get('email')
    password = data.get('password')
    user_type = data.get('userType')
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM User WHERE email = % s AND password = % s', (email, password,))
    user = cursor.fetchone()  
    if user:              
            session['loggedin'] = True
            session['userid'] = user['user_id']
            session['email'] = user['email']
            return jsonify({'message': 'Login successful'}), 200
    else:
            return jsonify({'message': 'Invalid credentials'}), 401

    # Check if the user exists and the password is correct
    #if email in users and users[email]['password'] == password:
        # Check if the user type matches
    #    if user_type == users[email]['user_type']:
    #        return jsonify({'message': 'Login successful'}), 200
    #    else:
    #        return jsonify({'message': 'Invalid user type'}), 400
    #else:
    #    return jsonify({'message': 'Invalid credentials'}), 401

@app.route('/register', methods=['GET', 'POST'])
def register():
    message = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM customer WHERE name = % s', (username,))
        account = cursor.fetchone()
        if account:
            message = 'Choose a different username!'

        elif not username or not password:
            message = 'Please fill out the form!'

        else:
            cursor.execute('INSERT INTO customer (cid, name) VALUES (% s, % s)', (password, username))
            mysql.connection.commit()
            message = 'User successfully created!'

    elif request.method == 'POST':

        message = 'Please fill all the fields!'
    #return render_template('register.html', message=message)


@app.route('/api', methods = ['GET'])
def returnascii():
    d = {}
    inputchr = str(request.args['query'])
    answer = str(ord(inputchr))
    d['output'] = answer
    return d



if __name__ =="__main__":
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, host='0.0.0.0', port=port)