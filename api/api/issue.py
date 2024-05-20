from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection
import math
import traceback
import uuid
from flask_jwt_extended import get_jwt_identity

issue_bp = Blueprint('issue', __name__, url_prefix='/issue')


@issue_bp.route('/createIssue', methods=['POST'])
def create_issue():
    try:
        # Get the identity (claims) from the JWT token
        identity = get_jwt_identity()
        
        # Extract user_id and user_type from the identity
        user_id = identity.get('user_id')
        user_type = identity.get('user_type')

        print("entered create issues")

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Extract data from request
        data = request.json
        issue_text = data.get('issue_text')
        issue_name = data.get('issue_name')
        date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        # Validate required data
        if not (issue_text and issue_name):
            return jsonify({'error': 'Missing required data'}), 400

        
        if user_type == "organizer":
            # Check if the user exists in either organizer or buyer table
            cursor.execute("SELECT * FROM organizer WHERE user_id = %s", (user_id,))
            organizer = cursor.fetchone()

            if organizer:
                user_id = organizer[0]
            else:
                return jsonify({'error': 'Organizer not found'}), 404
            
        elif user_type == "buyer":
            cursor.execute("SELECT * FROM buyer WHERE user_id = %s", (user_id,))
            buyer = cursor.fetchone()

            if buyer:
                user_id = buyer[0]
            else:
                return jsonify({'error': 'Buyer not found'}), 404
        else:
            return jsonify({'error': 'Uwrong user type'}), 404



        # Insert issue into issue table
        cursor.execute("INSERT INTO issue(issue_name, issue_text, date) VALUES (%s, %s, %s)",
                       (issue_name, issue_text, date))

        issue_id = cursor.lastrowid

        # Insert relation between user and issue
        if user_type == "organizer":
            cursor.execute("INSERT INTO make(issue_id, user_id) VALUES (%s, %s)", (issue_id, user_id))
        else:
            cursor.execute("INSERT INTO createe(issue_id, user_id) VALUES (%s, %s)", (issue_id, user_id))

        # Commit changes to the database
        connection.commit()

        return jsonify({'message': 'Issue created successfully', 'issue_id': issue_id}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@issue_bp.route('/browseIssues', methods=['GET'])
def browse_issues():
    try:
        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Construct SQL query to fetch all issues along with creator details and responses
        query = """
            SELECT i.issue_id, i.issue_name, i.issue_text, i.date, 
                COALESCE(o.first_name, b.first_name) AS creator_first_name,
                COALESCE(o.last_name, b.last_name) AS creator_last_name,
                COALESCE(o.user_type, b.user_type) AS creator_user_type,
                r.response_text, r.date AS response_date,
                wb.first_name AS responder_first_name,
                wb.last_name AS responder_last_name
            FROM issue i
            LEFT JOIN make m ON i.issue_id = m.issue_id
            LEFT JOIN createe c ON i.issue_id = c.issue_id
            LEFT JOIN organizer o ON m.user_id = o.user_id
            LEFT JOIN buyer b ON c.user_id = b.user_id
            LEFT JOIN respond r ON i.issue_id = r.issue_id
            LEFT JOIN worker_bee wb ON r.user_id = wb.user_id
        """

        # Execute the SQL query
        cursor.execute(query)

        # Fetch all rows
        issues = cursor.fetchall()

        # Close database connection
        cursor.close()
        connection.close()

        # Prepare response data
        issue_list = []
        print(issues[1])
        for issue in issues:
            issue_dict = {
                "issue_id": issue[0],
                "issue_name": issue[1],
                "issue_text": issue[2],
                "date": issue[3].strftime('%Y-%m-%d'),  # Format date as string
                "creator_name": f"{issue[4]} {issue[5]}",
                "creator_user_type": issue[6],
                "responses": []
            }
            if issue[7]:  # If there is a response
                response_dict = {
                    "response_text": issue[7],
                    "response_date": issue[8].strftime('%Y-%m-%d'),  # Format date as string
                    "responder_name": f"{issue[9]} {issue[10]}"
                }
                issue_dict["responses"].append(response_dict)

            issue_list.append(issue_dict)

        return jsonify(issue_list), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
