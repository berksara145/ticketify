from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection
import math
import traceback


response_bp = Blueprint('response', __name__, url_prefix='/response')


@response_bp.route('/createIssueResponse', methods=['POST'])
def create_issue_response():
    try:
        # Extract data from request
        data = request.json
        issue_id = data.get('issue_id')
        user_id = data.get('user_id')
        response_text = data.get('response_text')

        # Validate required data
        if not (issue_id and user_id and response_text):
            return jsonify({'error': 'Missing required data'}), 400

        # Get current date
        date = datetime.now().strftime('%Y-%m-%d')

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Check if the issue exists
        cursor.execute("SELECT * FROM issue WHERE issue_id = %s", (issue_id,))
        issue = cursor.fetchone()
        if not issue:
            return jsonify({'error': 'Issue does not exist'}), 404

        # Check if the user exists and is a worker bee
        cursor.execute("SELECT * FROM worker_bee WHERE user_id = %s", (user_id,))
        worker_bee = cursor.fetchone()
        if not worker_bee:
            return jsonify({'error': 'User does not exist or is not a worker bee'}), 404

        # Insert response into respond table
        cursor.execute("INSERT INTO respond(issue_id, user_id, date, response_text) VALUES (%s, %s, %s, %s)",
                       (issue_id, user_id, date, response_text))

        # Commit changes to the database
        connection.commit()

        # Close database connection
        cursor.close()
        connection.close()

        return jsonify({'message': 'Issue response created successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
