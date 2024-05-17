from flask import Flask, request, jsonify
import re
import os
from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
from flask_cors import CORS


from event import event_bp
from venue import venue_bp
from issue import issue_bp
from response import response_bp
from ticket import ticket_bp

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
app.register_blueprint(issue_bp)
app.register_blueprint(response_bp)
app.register_blueprint(ticket_bp)

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
    data = request.get_json()

    first_name = data.get('first_name')
    last_name = data.get('last_name')
    email = data.get('email')
    password = data.get('password')
    user_type = data.get('user_type')

    if not first_name or not last_name or not email or not password or not user_type:
        return jsonify({'message': 'All fields are required'}), 400

    # Check if email is valid
    if not re.match(r'[^@]+@[^@]+\.[^@]+', email):
        return jsonify({'message': 'Invalid email address'}), 400

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Check if the email is already registered
    cursor.execute('SELECT * FROM user WHERE email = %s', (email,))
    account = cursor.fetchone()

    if account:
        return jsonify({'message': 'Email is already registered'}), 400

    # Insert the new user into the database
    cursor.execute('INSERT INTO user (first_name, last_name, email, password, user_type) VALUES (%s, %s, %s, %s, %s)',
                   ( first_name, last_name, email, password, user_type))
    mysql.connection.commit()
    cursor.close()

    return jsonify({'message': 'User successfully registered'}), 200

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