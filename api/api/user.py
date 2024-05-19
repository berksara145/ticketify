from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection
import math
import traceback
import uuid
from flask_jwt_extended import get_jwt_identity

user_bp = Blueprint('user', __name__, url_prefix='/user')

@user_bp.route('/getUsers', methods=['POST'])
def getUsers():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        # Execute the query to fetch organizers
        cursor.execute("SELECT * FROM buyer")

        # Fetch all organizers
        buyers = cursor.fetchall()

        # Execute the query to fetch organizers
        cursor.execute("SELECT * FROM organizer")

        # Fetch all organizers
        organizers = cursor.fetchall()

        # Execute the query to fetch organizers
        cursor.execute("SELECT * FROM worker_bee")

        # Fetch all organizers
        worker_bees = cursor.fetchall()

        # Return the results as JSON
        return jsonify({'buyer': buyers, 'organizer': organizers, 'worker_bee': worker_bees}), 200

    except Exception as e:
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500

    finally:
        cursor.close()
        connection.close()


@user_bp.route('/deleteUser', methods=['DELETE'])
def deleteUser():
    try:
        # Extract parameters from request
        data = request.json
        user_id = data.get('user_id')
        user_type = data.get('user_type')

        if not (user_id and user_type is not None):
            return jsonify({'error': 'Missing required parameters'}), 400

        connection = get_db_connection()
        cursor = connection.cursor()

        # Construct the query to delete the user based on user_type
        query = f"DELETE FROM {user_type} WHERE user_id = %s"
        cursor.execute(query, (user_id,))

        # Commit the transaction
        connection.commit()

        # Return success response
        return jsonify({'message': 'User deleted successfully'}), 200

    except Exception as e:
        # Handle exceptions
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500

    finally:
        # Close cursor and connection
        cursor.close()
        connection.close()
