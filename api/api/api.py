from flask import Flask, request, jsonify
import re
import os
from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
from flask_cors import CORS


from event import event_bp
from venue import venue_bp


app = Flask(__name__)
CORS(app) 
app.secret_key = 'abcdefgh'

app.config['MYSQL_HOST'] = 'db'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password1212'
app.config['MYSQL_DB'] = 'cs353dbproject'

mysql = MySQL(app)


app.register_blueprint(event_bp)
app.register_blueprint(venue_bp)

def execute_schema_sql():
    print("handling schemas")
    with app.app_context():
        script_dir = os.path.dirname(__file__)
        schema_file_path = os.path.join(script_dir, 'schema.sql')
        with open(schema_file_path, 'r') as file:
            schema_sql = file.read()
            cursor = mysql.connection.cursor()
            try:
                # Execute the SQL commands only if the table 'user' does not exist
                cursor.execute("SHOW TABLES LIKE 'user'")
                result = cursor.fetchone()
                if result:
                    cursor.fetchall()
                    print("drop all tables")

                    # User table exists, drop all tables in the database
                    cursor.execute("SET FOREIGN_KEY_CHECKS=0")  # Disable foreign key checks
                    cursor.execute("SHOW TABLES")
                    tables = cursor.fetchall()
                    for table in tables:
                        table_name = table[0]
                        print("dropping", table_name)
                        cursor.execute(f"DROP TABLE IF EXISTS {table_name}")
                    cursor.execute("SET FOREIGN_KEY_CHECKS=1")  # Re-enable foreign key checks
                
                cursor.fetchall()
                
                # Execute the schema SQL to create tables
                cursor.execute(schema_sql)
                mysql.connection.commit()
                print("Schema executed and initial data inserted.")

            except mysql.connection.ProgrammingError as e:
                # Handle any exceptions
                print("Error:", e)
            finally:
                cursor.fetchall()
                cursor.close()

# Execute schema.sql file upon Flask application startup
execute_schema_sql()

#@app.route('/')
@app.route('/login', methods=['POST'])
def login():
       # Get email and password from request body
    email = request.json.get('email')
    password = request.json.get('password')

    # Check if email and password are provided
    if not email or not password:
        return jsonify({'message': 'Email and password are required'}), 404

    # Create MySQL cursor
    cur = mysql.connection.cursor()

    # Execute query to fetch user from 'user' table
    cur.execute('SELECT * FROM user WHERE email = % s AND password = % s', (email, password))

    # Fetch one row
    user = cur.fetchone()

    # Close cursor
    #cur.close()

    # Check if user exists
    if not user:
        print(email)
        print('here')
        print(password)
        return jsonify({'message': 'Invalid email or password'}), 401

    # User exists, return user data
    return jsonify({'user': user}), 200

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


if __name__ =="__main__":
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, host='0.0.0.0', port=port)

"""
cursor.execute("SHOW TABLES LIKE 'user'")
                result = cursor.fetchone()
                if result:
                    cursor.fetchall()
                    print("drop all tables")

                    # User table exists, drop all tables in the database
                    cursor.execute("SET FOREIGN_KEY_CHECKS=0")  # Disable foreign key checks
                    cursor.execute("SHOW TABLES")
                    tables = cursor.fetchall()
                    for table in tables:
                        table_name = table[0]
                        print("dropping", table_name)
                        cursor.execute(f"DROP TABLE IF EXISTS {table_name}")
                    cursor.execute("SET FOREIGN_KEY_CHECKS=1")  # Re-enable foreign key checks
                
                cursor.fetchall()
"""