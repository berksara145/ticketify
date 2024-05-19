from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection
from datetime import datetime
import traceback
import  logging


report_bp = Blueprint('report', __name__, url_prefix='/report')


from flask_jwt_extended import get_jwt_identity

# Function to check if a user is an admin
def is_admin(user_id, cursor):
    cursor.execute("SELECT * FROM admin WHERE user_id = %s", (user_id,))
    admin = cursor.fetchone()
    return admin is not None

# Function to check if an organizer exists
def organizer_exists(organizer_id, cursor):
    cursor.execute("SELECT * FROM organizer WHERE user_id = %s", (organizer_id,))
    organizer = cursor.fetchone()
    print(organizer)
    return organizer is not None

@report_bp.route('/createReport', methods=['POST'])
def create_report():
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    try:
        # Get the current user ID from the JWT
        identity = get_jwt_identity()

        # Extract user_id from the identity
        user_id = identity.get('user_id')

        # Check if the current user is an admin
        if not is_admin(user_id, cursor):
            return jsonify({'message': 'Unauthorized: Admin access required'}), 401

        # Get the request data
        data = request.get_json()
        start_date = data.get('start_date')
        end_date = data.get('end_date')
        organizer_id = data.get('organizer_id')

        # Validate inputs
        if not start_date or not end_date or not organizer_id:
            return jsonify({'message': 'Invalid input'}), 400

        # Check if the organizer exists
        if not organizer_exists(organizer_id, cursor):
            return jsonify({'message': 'Organizer not found'}), 404

        # Convert date strings to datetime objects for comparison
        start_date_dt = datetime.strptime(start_date, "%Y-%m-%d")
        end_date_dt = datetime.strptime(end_date, "%Y-%m-%d")

        # Calculate total revenue from sold tickets for each event organized by the organizer
        cursor.execute("""
            SELECT e.event_id, e.event_name, SUM(t.ticket_price) AS total_revenue
            FROM tickets t
            JOIN event_has_ticket eht ON t.ticket_id = eht.ticket_id
            JOIN organization_organize_event ooe ON eht.event_id = ooe.event_id
            JOIN event e ON ooe.event_id = e.event_id
            WHERE ooe.user_id = %s
              AND t.is_bought = TRUE
              AND e.start_date >= %s
              AND e.end_date <= %s
            GROUP BY e.event_id, e.event_name
        """, (organizer_id, start_date, end_date))

        events_revenue = cursor.fetchall()

        # Insert the report into the reports table
        for event in events_revenue:
            cursor.execute("""
                INSERT INTO report (organizer_id, event_id, total_revenue, start_date, end_date, generated_by)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (organizer_id, event['event_id'], event['total_revenue'], start_date_dt, end_date_dt, user_id))
            # Commit the transaction
            connection.commit()


        # Format the response
        response = []
        for event in events_revenue:
            response.append({
                'event_id': event['event_id'],
                'event_name': event['event_name'],
                'total_revenue': event['total_revenue'] if event['total_revenue'] is not None else 0
            })

        return jsonify(response), 200

    except Exception as e:
        connection.rollback()  # Rollback in case of error
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500

    finally:
        cursor.close()
        connection.close()


@report_bp.route('/getOrganizers', methods=['GET'])
def get_organizers():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        # Execute the query to fetch organizers
        cursor.execute("SELECT user_id, CONCAT(first_name, ' ', last_name) AS name FROM organizer")

        # Fetch all organizers
        organizers = cursor.fetchall()

        return jsonify(organizers), 200

    except Exception as e:
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500

    finally:
        cursor.close()
        connection.close()

@report_bp.route('/getReports', methods=['GET'])
def get_reports():
    # Configure logging
    logging.basicConfig(filename='app.log', level=logging.DEBUG)

    try:
        logging.debug('Attempting to fetch reports')

        # Get the current user ID from the JWT
        current_user_id = get_jwt_identity().get('user_id')

        # Get database connection and cursor
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        if not is_admin(current_user_id, cursor):
            logging.warning('Unauthorized access: Admin access required')
            return jsonify({'message': 'Unauthorized: Admin access required'}), 401

        # Execute SQL query to fetch reports for the current user
        cursor.execute("SELECT * FROM report WHERE generated_by = %s", (current_user_id))

        # Fetch all reports
        reports = cursor.fetchall()
        print(reports)
        logging.debug('Reports fetched successfully')

        return jsonify(reports), 200

    except Exception as e:
        logging.error(f'Error occurred: {e}')
        error_message = {'error': str(e), 'trace': traceback.format_exc()}
        return jsonify(error_message), 500

    finally:
        cursor.close()
        connection.close()
