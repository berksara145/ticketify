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

