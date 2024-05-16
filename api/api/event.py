from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection


event_bp = Blueprint('event', __name__, url_prefix='/event')


# burada ticket logici çözülmeli daha yapmadım bide sqlde de table değişcek
@event_bp.route('/create_event', methods=['POST'])
def create_event():
    try:
        # Extract data from request
        data = request.json
        event_id = data.get('event_id')
        event_name = data.get('event_name')
        start_date = data.get('start_date')
        end_date = data.get('end_date')
        event_category = data.get('event_category')
        event_image = data.get('event_image')
        description_text = data.get('description_text')
        event_rules = data.get('event_rules')
        organizer_id = data.get('organizer_id')
        venue_id = data.get('venue_id')
        performer_name = data.get('performer_name')

        # Validate required data
        if not (event_id and event_name and start_date and end_date and event_category
                and event_image and description_text and event_rules and organizer_id and venue_id and performer_name):
            return jsonify({'error': 'Missing required data'}), 400

        # Convert date strings to datetime objects
        start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
        end_date = datetime.strptime(end_date, '%Y-%m-%d').date()

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Check if organizer exists
        cursor.execute("SELECT * FROM organizer WHERE user_id = %s", (organizer_id,))
        organizer = cursor.fetchone()
        if not organizer:
            return jsonify({'error': 'Organizer not found'}), 404

        # Insert performer into performer table
        performer_insert_query = """
        INSERT INTO performer(performer_name)
        VALUES (%s)
        """
        cursor.execute(performer_insert_query, (performer_name,))

        performer_id = cursor.lastrowid  # Get the ID of the newly inserted performer

        # Insert event into event table
        event_insert_query = """
        INSERT INTO event(event_id, event_name, start_date, end_date, event_category,
        url_photo, description_text, event_rules)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(event_insert_query, (event_id, event_name, start_date, end_date,
                                             event_category, event_image, description_text, event_rules))

        # Add relation between organizer, event, and performer
        organizer_event_insert_query = """
        INSERT INTO organizer_organize_event(user_id, event_id, venue_id)
        VALUES (%s, %s, %s)
        """
        cursor.execute(organizer_event_insert_query, (organizer_id, event_id, venue_id))

        event_performer_insert_query = """
        INSERT INTO event_performer(event_id, performer_id)
        VALUES (%s, %s)
        """
        cursor.execute(event_performer_insert_query, (event_id, performer_id))

        # Commit changes to the database
        connection.commit()

        # Close database connection
        cursor.close()
        connection.close()

        return jsonify({'message': 'Event created successfully', 'event_id': event_id}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500