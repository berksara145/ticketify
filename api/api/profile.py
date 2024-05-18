from flask import Blueprint, request, jsonify
from utils import get_db_connection
import math
import traceback
import uuid
from flask_jwt_extended import get_jwt_identity

profile_bp = Blueprint('profile', __name__, url_prefix='/profile')
@profile_bp.route('/change_name', methods=['POST', 'OPTIONS'])
def change_name():
    if request.method == 'OPTIONS':
        response = make_response()
        response.headers['Access-Control-Allow-Origin'] = '*'
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
        response.headers['Access-Control-Allow-Methods'] = 'POST'
        return response
    try:
        # Get the identity (claims) from the JWT token
        identity = get_jwt_identity()

        # Extract user_id and user_type from the identity
        user_id = identity.get('user_id')
        user_type = identity.get('user_type')

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Extract data from request
        data = request.json
        new_name = data.get('first_name')
        new_lastname = data.get('last_name')

        # Validate required data
        if not (new_name or new_lastname):
            return jsonify({'error': 'No changes provided'}), 400

        # Update the buyer's first name if provided
        if new_name:
            cursor.execute("UPDATE buyer SET first_name = %s WHERE user_id = %s", (new_name, user_id))

        # Update the buyer's last name if provided
        if new_lastname:
            cursor.execute("UPDATE buyer SET last_name = %s WHERE user_id = %s", (new_lastname, user_id))

        connection.commit()
        return jsonify({'message': 'Changes saved successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


