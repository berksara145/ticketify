from flask import Blueprint, request, jsonify
from utils import get_db_connection

venue_bp = Blueprint('venue', __name__, url_prefix='/venue')


from flask_jwt_extended import get_jwt_identity

"""
-- Table: generate
CREATE TABLE IF NOT EXISTS  generate (
    user_id INT,
    venue_id INT,
    PRIMARY KEY (user_id, venue_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);
bu talbe relation eklenmeli create e unutulmuş
"""

# Endpoint to create a venue and associate it with an event
@venue_bp.route('/create', methods=['POST'])
def create_venue():
    # Get the identity (claims) from the JWT token
    identity = get_jwt_identity()
    
    # Extract user_id and user_type from the identity
    user_id = identity.get('user_id')

    # Extract data from request
    data = request.json
    venue_name = data.get('venue_name')
    address = data.get('address')
    phone_no = data.get('phone_no')
    venue_image = data.get('venue_image')
    venue_row_length = data.get('venue_row_length')
    venue_column_length = data.get('venue_column_length')
    venue_section_count = data.get('venue_section_count')

    # Validate required data
    if not (venue_name and address and phone_no and venue_image and
            venue_row_length and venue_column_length and venue_section_count and user_id):
        return jsonify({'error': 'Missing required data'}), 400

    try:
        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        print("creating venue")
        # Insert venue into venue table
        venue_insert_query = """
        INSERT INTO venue(venue_name, address, phone_no, venue_section_count, url_photo,
        venue_row_length, venue_column_length)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(venue_insert_query, (venue_name, address, phone_no, venue_section_count,
                                             venue_image, venue_row_length, venue_column_length))

        venue_id = cursor.lastrowid  # Get the ID of the newly inserted venue

        print("creating seats")
        # Iterate over rows and columns to create seat entries
        for row in range(1, venue_row_length + 1):
            for column in range(1, venue_column_length + 1):
                seat_position = f"{chr(64 + row)}{column}"  # Convert row number to letter (A, B, C, ...)
                cursor.execute("INSERT INTO seats (seat_position, venue_id) VALUES (%s, %s)", (seat_position, venue_id))

        # Insert into generate table
        cursor.execute("INSERT INTO generate (user_id, venue_id) VALUES (%s, %s)", (user_id, venue_id))

        # Commit changes to the database
        connection.commit()

        # Close database connection
        cursor.close()
        connection.close()
        print("creating venue seats done")
        return jsonify({'message': 'Venue created successfully', 'venue_id': venue_id}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Endpoint to fetch all venues and their associated seats
@venue_bp.route('/getVenue', methods=['GET'])
def get_all_venues():
    try:
        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        # Retrieve all venues
        cursor.execute("SELECT * FROM venue")
        venues = cursor.fetchall()

        # Retrieve seats for each venue
        for venue in venues:
            venue_id = venue['venue_id']
            cursor.execute("SELECT * FROM seats WHERE venue_id = %s", (venue_id,))
            seats = cursor.fetchall()
            venue['seats'] = seats

        # Close database connection
        cursor.close()
        connection.close()

        return jsonify({'venues': venues}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
