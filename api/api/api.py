from flask import Flask, request, jsonify
import re
import os
from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
from flask_cors import CORS
from flask_jwt_extended import create_access_token
from flask_jwt_extended import JWTManager
import traceback

from middleware import check_access_token, expired_token_callback, invalid_token_callback, unauthorized_callback, needs_fresh_token_callback, revoked_token_callback
from event import event_bp
from venue import venue_bp
from issue import issue_bp
from response import response_bp
from ticket import ticket_bp
from report import report_bp
from profile import profile_bp
from user import user_bp

app = Flask(__name__)
CORS(app) 
app.secret_key = 'abcdefgh'

app.config['MYSQL_HOST'] = 'db'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password1212'
app.config['MYSQL_DB'] = 'cs353dbproject'

mysql = MySQL(app)

# Set JWT_VERIFY_SUB to False (this disables the verification of the sub claim)
app.config['JWT_VERIFY_SUB'] = False
app.config['JWT_SECRET_KEY'] = 'very secret key'  # Change this to your preferred secret key
jwt = JWTManager(app)



# Register custom error handlers for JWT exceptions
jwt.expired_token_loader(expired_token_callback)
jwt.invalid_token_loader(invalid_token_callback)
jwt.unauthorized_loader(unauthorized_callback)
jwt.needs_fresh_token_loader(needs_fresh_token_callback)
jwt.revoked_token_loader(revoked_token_callback)


# Registerings
event_bp.before_request(check_access_token)
app.register_blueprint(event_bp)

venue_bp.before_request(check_access_token)
app.register_blueprint(venue_bp)

issue_bp.before_request(check_access_token)
app.register_blueprint(issue_bp)

response_bp.before_request(check_access_token)
app.register_blueprint(response_bp)

ticket_bp.before_request(check_access_token)
app.register_blueprint(ticket_bp)

report_bp.before_request(check_access_token)
app.register_blueprint(report_bp)

profile_bp.before_request(check_access_token)
app.register_blueprint(profile_bp)

user_bp.before_request(check_access_token)
app.register_blueprint(user_bp)


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
@app.route('/login', methods=['POST'])
def login():
    try:
        # Get email, password, and user_type from request body
        email = request.json.get('email')
        password = request.json.get('password')
        user_type = request.json.get('user_type')

        # Check if email, password, and user_type are provided
        if not email or not password or not user_type:
            return jsonify({'message': 'Email, password, and user type are required'}), 404

        # Create MySQL cursor
        cur = mysql.connection.cursor()

        # Execute query to fetch user from 'user' table
        cur.execute(f'SELECT * FROM {user_type} WHERE email = %s AND password = %s', (email, password))

        # Fetch one row
        user = cur.fetchone()

        # Close cursor
        cur.close()

        # Check if user exists
        if not user:
            return jsonify({'message': 'Invalid email or password'}), 401

        # Generate JWT token
        access_token = create_access_token(identity={'user_id': user[0], 'email': user[5], 'user_type': user_type})

        # Return user data along with JWT token
        return jsonify({'user': user, 'access_token': access_token}), 200

    except Exception as e:
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500
@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        print(f"Received data: {data}")

        first_name = data.get('first_name')
        last_name = data.get('last_name')
        email = data.get('email')
        password = data.get('password')
        user_type = data.get('user_type')
        phone_no = data.get('phone')

        print(f"First Name: {first_name}, Last Name: {last_name}, Email: {email}, User Type: {user_type}, Phone: {phone_no}")
        
        if not first_name or not last_name or not email or not password or not user_type:
            print("Missing required fields")
            return jsonify({'message': 'All fields are required'}), 400

        if user_type == 'organizor':
            if not phone_no:
                print("Phone number is required for organizers")
                return jsonify({'message': 'Organizors are required to enter phone no.'}), 400

        # Check if email is valid
        if not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            print(f"Invalid email address: {email}")
            return jsonify({'message': 'Invalid email address'}), 400

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # Check if the email is already registered
        cursor.execute(f"SELECT * FROM {user_type} WHERE email = %s", (email,))
        account = cursor.fetchone()
        print(f"Account found: {account}")

        if account:
            print("Email already registered")
            return jsonify({'message': 'Email is already registered'}), 400

        # Insert the new user into the database
        if user_type == 'organizer':
            print(f"Inserting organizer with phone number: {phone_no}")
            cursor.execute(f"INSERT INTO {user_type} (first_name, last_name, email, password, user_type, phone_no) VALUES (%s, %s, %s, %s, %s, %s)",
                       (first_name, last_name, email, password, user_type, phone_no))
        elif user_type == 'buyer':
            print("Inserting buyer with initial money = 0")
            cursor.execute(f"INSERT INTO {user_type} (password, money, first_name, last_name, email, user_type) VALUES (%s, %s, %s, %s, %s, %s)",
                       (password, 0, first_name, last_name, email, user_type))
        else:
            print("Inserting other user type")
            cursor.execute(f"INSERT INTO {user_type} (first_name, last_name, email, password, user_type) VALUES (%s, %s, %s, %s, %s)",
                        (first_name, last_name, email, password, user_type))

        # Retrieve the created user
        cursor.execute(f"SELECT * FROM {user_type} WHERE email = %s", (email,))
        created_user = cursor.fetchone()
        print(f"Created user: {created_user}")

        mysql.connection.commit()
        cursor.close()

        return jsonify({'message': 'User successfully registered', "user": created_user}), 200
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500


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