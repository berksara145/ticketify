from flask import Blueprint, request, jsonify
from utils import get_db_connection
import math
import traceback
import uuid
from flask_jwt_extended import get_jwt_identity
import logging

profile_bp = Blueprint('profile', __name__, url_prefix='/profile')
logger = logging.getLogger(__name__)
@profile_bp.route('/change_name', methods=['POST'])
def change_name():
    try:
        identity = get_jwt_identity()
        user_id = identity.get('user_id')
        user_type = identity.get('user_type')

        connection = get_db_connection()
        cursor = connection.cursor()

        data = request.json
        new_name = data.get('first_name')
        new_lastname = data.get('last_name')

        if not (new_name or new_lastname):
            return jsonify({'error': 'No changes provided'}), 400

        if new_name:
            cursor.execute(f"UPDATE {user_type} SET first_name = %s WHERE user_id = %s", (new_name, user_id))

        if new_lastname:
            cursor.execute(f"UPDATE {user_type} SET last_name = %s WHERE user_id = %s", (new_lastname, user_id))

        connection.commit()
        return jsonify({'message': 'Changes saved successfully'}), 200

    except Exception as e:
        logger.exception("An error occurred while changing name")
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        connection.close()

@profile_bp.route('/get_user_details', methods=['GET'])
def get_user_details():
    try:
        identity = get_jwt_identity()
        user_id = identity.get('user_id')
        user_type = identity.get('user_type')

        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute(f"SELECT first_name, last_name, user_id FROM {user_type} WHERE user_id = %s", (user_id,))
        user = cursor.fetchone()

        if user:
            return jsonify({'first_name': user[0], 'last_name': user[1], 'user_type': user[2]}), 200
        else:
            return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        logger.exception("An error occurred while fetching user details")
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        connection.close()

@profile_bp.route('/change_password', methods=['POST'])
def change_password():
    connection = None
    cursor = None
    try:
        current_user = get_jwt_identity()
        user_id = current_user['user_id']
        user_type = current_user['user_type']

        data = request.json
        old_password = data.get('password_old')
        new_password = data.get('password_new1')
        new_password2 = data.get('password_new2')

        if not (user_id and old_password and new_password and new_password2):
            return jsonify({'error': 'Missing required data'}), 400

        if new_password != new_password2:
            return jsonify({'error': 'New passwords do not match'}), 400

        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute(f"SELECT password FROM {user_type} WHERE user_id = %s", (user_id,))
        user = cursor.fetchone()

        if user:
            if user[0] == old_password:
                cursor.execute(f"UPDATE {user_type} SET password = %s WHERE user_id = %s", (new_password, user_id))
                connection.commit()
                return jsonify({'message': 'Password changed successfully'}), 200
            else:
                return jsonify({'error': 'Invalid old password'}), 401
        else:
            return jsonify({'error': 'User not found'}), 404

    except Exception as e:
        logger.exception("An error occurred during password change")
        return jsonify({'error': 'An unexpected error occurred'}), 500
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()