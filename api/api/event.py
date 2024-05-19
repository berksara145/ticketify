from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection
import math
import traceback

from flask_jwt_extended import get_jwt_identity

event_bp = Blueprint('event', __name__, url_prefix='/event')


# Event GET all endpoint
@event_bp.route('/getAllEvents', methods=['GET'])
def get_all_events():
    try:
        print("entered get all events")

        event_query = """
            SELECT e.event_id, e.event_name, e.start_date, e.end_date, e.event_category,
                e.ticket_prices, e.url_photo AS event_photo, e.description_text, e.event_rules,
                v.venue_name, v.address, v.url_photo AS venue_photo,
                p.performer_name, o.first_name AS organizer_first_name, o.last_name AS organizer_last_name
            FROM event_in_venue eiv
            INNER JOIN event e ON eiv.event_id = e.event_id
            INNER JOIN venue v ON eiv.venue_id = v.venue_id
            INNER JOIN perform pf ON e.event_id = pf.event_id
            INNER JOIN performer p ON pf.performer_id = p.performer_id
            INNER JOIN organization_organize_event oo ON e.event_id = oo.event_id
            INNER JOIN organizer o ON oo.user_id = o.user_id
            ORDER BY e.start_date DESC;
        """

                
        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Execute SQL query to join event_in_venue and venue tables
        cursor.execute(event_query)
        events = cursor.fetchall()
        
        # Convert result to list of dictionaries
        event_list = []
        for event in events:
            event_dict = {
                "event_id": event[0],
                "event_name": event[1],
                "start_date": event[2],  # Format date as string
                "end_date": event[3],  # Format date as string
                "event_category": event[4],
                "ticket_prices": event[5],  # Convert ticket prices to list
                "url_photo": event[6],
                "description_text": event[7],
                "event_rules": event[8],
                "venue": {  # Nested dictionary for venue
                    "venue_name": event[9],
                    "address": event[10],
                    "url_photo": event[11]
                },
                "performer_name": event[12],
                "organizer_first_name": event[13], 
                "organizer_last_name": event[14]

            }
            event_list.append(event_dict)
        
        print(event_list)

        return jsonify(event_list), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@event_bp.route('/getEvents', methods=['GET'])
def get_user_events():
    try:
        print("entered get events")

        identity = get_jwt_identity()
        
        # Extract user_id from the identity
        organizer_id = identity.get('user_id')

        # Construct the SQL query to fetch events created by the user
        event_query = """
            SELECT e.event_id, e.event_name, e.start_date, e.end_date, e.event_category,
                e.ticket_prices, e.url_photo AS event_photo, e.description_text, e.event_rules,
                v.venue_name, v.address, v.url_photo AS venue_photo,
                p.performer_name, o.first_name AS organizer_first_name, o.last_name AS organizer_last_name
            FROM event_in_venue eiv
            INNER JOIN event e ON eiv.event_id = e.event_id
            INNER JOIN venue v ON eiv.venue_id = v.venue_id
            INNER JOIN perform pf ON e.event_id = pf.event_id
            INNER JOIN performer p ON pf.performer_id = p.performer_id
            INNER JOIN organization_organize_event oo ON e.event_id = oo.event_id
            INNER JOIN organizer o ON oo.user_id = o.user_id
            INNER JOIN generate g ON o.user_id = g.user_id  -- Join with generate table
            WHERE g.user_id = %s  -- Filter by user_id
            ORDER BY e.start_date DESC;
        """

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Execute the SQL query with user_id as parameter
        cursor.execute(event_query, (organizer_id,))
        events = cursor.fetchall()
        
        # Convert result to list of dictionaries
        event_list = []
        for event in events:
            event_dict = {
                "event_id": event[0],
                "event_name": event[1],
                "start_date": event[2],  # Format date as string
                "end_date": event[3],  # Format date as string
                "event_category": event[4],
                "ticket_prices": event[5].split('-'),  # Convert ticket prices to list
                "url_photo": event[6],
                "description_text": event[7],
                "event_rules": event[8],
                "venue": {  # Nested dictionary for venue
                    "venue_name": event[9],
                    "address": event[10],
                    "url_photo": event[11]
                },
                "performer_name": event[12],
                "organizer_first_name": event[13], 
                "organizer_last_name": event[14]

            }
            event_list.append(event_dict)
        
        # Close database connection
        cursor.close()
        connection.close()

        return jsonify(event_list), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# burada ticket logici çözülmeli daha yapmadım bide sqlde de table değişcek
@event_bp.route('/createEvent', methods=['POST'])
def create_event():
    try:
        print("entered create event")

        identity = get_jwt_identity()
        
        # Extract user_id and user_type from the identity
        organizer_id = identity.get('user_id')

        # Extract data from request
        data = request.json
        event_name = data.get('event_name')
        start_date = data.get('start_date')
        end_date = data.get('end_date')
        event_category = data.get('event_category')
        event_image = data.get('event_image')
        description_text = data.get('description_text')
        event_rules = data.get('event_rules')
        venue_id = data.get('venue_id')
        ticket_prices = data.get('ticket_prices')  # Array of ticket prices)
        performer_name = "performerr"

        # Validate required data
        if not ( event_name and start_date and end_date and event_category
                and event_image and description_text and event_rules and organizer_id and venue_id 
                and ticket_prices):
            return jsonify({'error': 'Missing required data'}), 400

        # Convert date strings to datetime objects
        start_date = datetime.strptime(start_date, '%Y-%m-%d %H:%M:%S.%f').date()
        end_date = datetime.strptime(end_date, '%Y-%m-%d %H:%M:%S.%f').date()

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Check if organizer exists
        cursor.execute("SELECT * FROM organizer WHERE user_id = %s", (organizer_id,))
        organizer = cursor.fetchone()
        
        if organizer:
            organizer_id = organizer[0]  # Assuming organizer_id is the first column in the organizer table
            organizer_name = organizer[2]  # Assuming organizer_name is the second column in the organizer table
            print(f"Organizer found with ID: {organizer_id} and Name: {organizer_name}")
        else:
            print("Organizer not found")
            return jsonify({'error': 'Organizer not found'}), 404


        # Insert performer into performer table
        performer_insert_query = """
        INSERT INTO performer(performer_name)
        VALUES (%s)
        """
        cursor.execute(performer_insert_query, (performer_name,))

        performer_id = cursor.lastrowid  # Get the ID of the newly inserted performer

        print(f"Performer ID: {performer_id}, Performer Name: {performer_name}, Insertion successful")

        # Convert list of ticket prices to a string separated by '-'
        ticket_prices_str = '-'.join(map(str, ticket_prices))

        # Insert into the event table with ticket_prices_str
        event_insert_query = """
            INSERT INTO event(event_name, start_date, end_date, event_category,
            ticket_prices, url_photo, description_text, event_rules)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(event_insert_query, (event_name, start_date, end_date,
                                            event_category, ticket_prices_str,
                                            event_image, description_text, event_rules))

        event_id = cursor.lastrowid  # Get the ID of the newly inserted performer

        print(f"Event created with ID: {event_id}")

        # Insert into the event_in_venue table
        event_in_venue_insert_query = """
            INSERT INTO event_in_venue(event_id, venue_id)
            VALUES (%s, %s)
        """
        cursor.execute(event_in_venue_insert_query, (event_id, venue_id))

        print(f"Event venue relation added")

        # Add relation between organizer, event
        organizer_event_insert_query = """
        INSERT INTO organization_organize_event(user_id, event_id)
        VALUES (%s, %s)
        """
        cursor.execute(organizer_event_insert_query, (organizer_id, event_id))

        print(f"Event organizer relation added")

        event_performer_insert_query = """
        INSERT INTO perform(event_id, performer_id)
        VALUES (%s, %s)
        """
        cursor.execute(event_performer_insert_query, (event_id, performer_id))

        print(f"Event performer relation added")

        # Retrieve venue from the database based on venue_id
        cursor.execute("SELECT * FROM venue WHERE venue_id = %s", (venue_id,))
        venue = cursor.fetchall()
        
        if not venue:
            raise ValueError(f"No venue found with venue_id {venue_id}")

        # Extract relevant information from the retrieved venue
        venue_id = venue[0][0] 
        venue_name = venue[0][1] 
        section_count = venue[0][4]  # Assuming section_count is the 5th column (index 4)
        row_length = venue[0][6]  # Assuming venue_row_length is the 7th column (index 6)
        column_length = venue[0][7]  # Assuming venue_column_length is the 8th column (index 7)

        print(f"Venue ID: {venue_id}, Venue Name: {venue_name}, Section Count: {section_count}, Row Length: {row_length}, Column Length: {column_length}")

        # Calculate total seat count
        total_seats = row_length * column_length

        # Calculate the number of seats per section
        seats_per_section = total_seats // section_count

        # If there are any remaining seats after distributing evenly
        remaining_seats = total_seats % section_count

        print(f"total_seats: {total_seats}, seats_per_section: {seats_per_section}, remaining_seats: {remaining_seats}")

        #create tickets
        # Create a list to store the seat counts for each section
        #event_has_ticket event ticket bağla
        #ticket_seat ticket seat bağla ama seat kendin üret biliyon ztn çekmene gerek yok
        for i in range(section_count):
            for j in range(seats_per_section):
                seat_num = i * seats_per_section + j + 1 #in total seat_num
                print(f"seatnum: {seat_num}")
                letter = math.ceil(seat_num / row_length) #gives seat letter
                num = (seat_num % row_length ) # gives seat num in row
                if(num == 0):
                    num = row_length

                ticket_id = create_tickets(event_id, ticket_prices[i], "", cursor)
                insert_ticket_seat_entry(ticket_id, str(chr(ord('A') + letter - 1)) + str(num), cursor)

        for j in range(remaining_seats):
            seat_num = section_count * seats_per_section + j + 1 #in total seat_num
            print(f"seatnum: {seat_num}")
            letter = math.ceil(seat_num / row_length) #gives seat letter
            num = (seat_num % row_length ) # gives seat num in row
            if(num == 0):
                num = row_length

            ticket_id = create_tickets(event_id, ticket_prices[i], "", cursor)
            insert_ticket_seat_entry(ticket_id, str(chr(ord('A') + letter - 1)) + str(num), cursor)

        # Commit changes to the database
        connection.commit()

        # Close database connection
        cursor.close()
        connection.close()

        return jsonify({'message': 'Event created successfully', 'event_id': event_id}), 200

    except Exception as e:
        traceback_info = traceback.format_exc()
        return jsonify({'error': str(e), 'traceback': traceback_info}), 500

def insert_ticket_seat_entry(ticket_id, seat_position, cursor):
    try:
        print(f"Inserting entry into ticket_seat table with Ticket ID: {ticket_id}, Seat Position: {seat_position}")

        # SQL query to insert an entry into the ticket_seat table
        sql_query = "INSERT INTO ticket_seat (ticket_id, seat_position) VALUES (%s, %s)"
        
        # Tuple containing values to be inserted
        values = (ticket_id, seat_position)

        # Execute the SQL query
        cursor.execute(sql_query, values)

        
        print("Entry inserted into ticket_seat table successfully")

    except Exception as e:
        print("Error inserting entry into ticket_seat table:", e)
        raise  # Re-raise the exception here

def create_tickets(event_id, ticket_price, barcode, cursor):
    try:

        print(f"Creating ticket for event ID: {event_id}, Ticket price: {ticket_price}, Barcode: {barcode}")
        is_bought = False  # By default, the ticket is not bought

        # Insert ticket data into the tickets table
        cursor.execute("INSERT INTO tickets (ticket_barcode, ticket_price, is_bought) VALUES (%s, %s, %s)",
                        (barcode, ticket_price, is_bought))
        ticket_id = cursor.lastrowid  # Get the ID of the newly inserted ticket
        # Create a relation between the event and the ticket
        cursor.execute("INSERT INTO event_has_ticket (event_id, ticket_id) VALUES (%s, %s)",
                        (event_id, ticket_id))

        print(f"ticket created successfully and added to event {event_id}")
        return ticket_id
    except Exception as e:
        print("Error creating tickets:", e)
        raise
        

        
@event_bp.route('/getFilteredEvents', methods=['POST'])
def get_filtered_events():
    try:
        print("entered fileted event get")
        data = request.json

        # Extract query parameters
        category_name = data.get('selected_categories', '')
        start_date = data.get('start_date', '')
        end_date = data.get('end_date', '')
        ticket_price_min = data.get('min_price', '')
        ticket_price_max = data.get('max_price', '')
        event_name = data.get('event_name', '')

        print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
        print("Category Name:", category_name)
        print("Start Date:", start_date)
        print("End Date:", end_date)
        print("Ticket Price Min:", ticket_price_min)
        print("Ticket Price Max:", ticket_price_max)
        print("Event Name:", event_name)

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Build the base query
        query = """
        SELECT e.event_id, e.event_name, e.start_date, e.end_date, e.event_category,
        e.ticket_prices, e.url_photo, e.description_text, e.event_rules,
        v.venue_name, v.address, v.url_photo,
        pe.performer_name,
        o.first_name, o.last_name
        FROM event AS e
        LEFT JOIN event_in_venue AS ev ON e.event_id = ev.event_id
        LEFT JOIN venue AS v ON ev.venue_id = v.venue_id
        LEFT JOIN organization_organize_event AS oe ON e.event_id = oe.event_id
        LEFT JOIN organizer AS o ON oe.user_id = o.user_id
        LEFT JOIN perform AS p ON e.event_id = p.event_id
        LEFT JOIN performer AS pe ON p.performer_id = pe.performer_id
        WHERE 1=1
        """

        # List to hold query parameters
        query_params = []

        # Add filters to the query if they are provided
        if category_name:
            query += " AND e.event_category = %s"
            query_params.append(category_name)
        if start_date:
            query += " AND e.start_date >= %s"
            query_params.append(start_date)
        if end_date:
            query += " AND e.end_date <= %s"
            query_params.append(end_date)
        if ticket_price_min:
            query += " AND CAST(SUBSTRING_INDEX(e.ticket_prices, '-', 1) AS DECIMAL) >= %s"
            query_params.append(ticket_price_min)
        if ticket_price_max:
            query += " AND CAST(SUBSTRING_INDEX(e.ticket_prices, '-', -1) AS DECIMAL) <= %s"
            query_params.append(ticket_price_max)
        if event_name:
            query += " AND e.event_name LIKE %s"
            query_params.append(f"%{event_name}%")

        # Execute the query
        cursor.execute(query, query_params)

        # Fetch all matching events
        events = cursor.fetchall()

        if not events:  # If no events found
            return jsonify([]), 204 # or perform any other action
        else:
            # Close the cursor and connection
            cursor.close()
            connection.close()

            # Format the results
            result = []
            for event in events:
                event_dict = {
                    "event_id": event[0],
                    "event_name": event[1],
                    "start_date": event[2],  # Format date as string
                    "end_date": event[3],  # Format date as string
                    "event_category": event[4],
                    "ticket_prices": event[5],  # Convert ticket prices to list
                    "url_photo": event[6],
                    "description_text": event[7],
                    "event_rules": event[8],
                    "venue": {  # Nested dictionary for venue
                        "venue_name": event[9],
                        "address": event[10],
                        "url_photo": event[11]
                    },
                    "performer_name": event[12],
                    "organizer_first_name": event[13],
                    "organizer_last_name": event[14]
                }
            result.append(event_dict)
            return jsonify(result), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500



@event_bp.route('/addEventClicked', methods=['POST'])
def add_event_clicked():
    try:
        # Get the identity (claims) from the JWT token
        identity = get_jwt_identity()
        
        # Extract user_id and user_type from the identity
        user_id = identity.get('user_id')

        # Extract data from the request
        data = request.json
        event_id = data.get('event_id')
        
        # Validate required data
        if not (user_id and event_id):
            return jsonify({'error': 'Missing required data'}), 400

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Check if the user exists
        cursor.execute("SELECT * FROM buyer WHERE user_id = %s", (user_id,))
        if not cursor.fetchone():
            return jsonify({'error': 'User does not exist'}), 404

        # Check if the event exists
        cursor.execute("SELECT * FROM event WHERE event_id = %s", (event_id,))
        if not cursor.fetchone():
            return jsonify({'error': 'Event does not exist'}), 404

        # Insert or update the browse table with the click information
        cursor.execute("INSERT INTO browse (user_id, event_id) VALUES (%s, %s) ON DUPLICATE KEY UPDATE user_id=%s", (user_id, event_id, user_id))

        # Commit changes to the database
        connection.commit()

        # Close database connection
        cursor.close()
        connection.close()

        return jsonify({'message': 'Event click information stored successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500



@event_bp.route('/getEventsClicked', methods=['GET'])
def get_events_clicked():
    try:
        # Get the identity (claims) from the JWT token
        identity = get_jwt_identity()
        
        # Extract user_id and user_type from the identity
        user_id = identity.get('user_id')

        # Validate user_id
        if not user_id:
            return jsonify({'error': 'Missing user_id parameter'}), 400

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Check if the user exists
        cursor.execute("SELECT * FROM buyer WHERE user_id = %s", (user_id,))
        if not cursor.fetchone():
            return jsonify({'error': 'User does not exist'}), 404

        # Retrieve events clicked by the user with detailed information
        cursor.execute("""
            SELECT e.event_id, e.event_name, e.start_date, e.end_date, e.event_category,
                   e.ticket_prices, e.url_photo, e.description_text, e.event_rules,
                   v.venue_name, v.address, v.url_photo,
                   pe.performer_name,
                   o.first_name, o.last_name
            FROM event AS e
            LEFT JOIN event_in_venue AS ev ON e.event_id = ev.event_id
            LEFT JOIN venue AS v ON ev.venue_id = v.venue_id
            LEFT JOIN organization_organize_event AS oe ON e.event_id = oe.event_id
            LEFT JOIN organizer AS o ON oe.user_id = o.user_id
            LEFT JOIN perform AS p ON e.event_id = p.event_id
            LEFT JOIN performer AS pe ON p.performer_id = pe.performer_id
            INNER JOIN browse AS b ON e.event_id = b.event_id
            WHERE b.user_id = %s
        """, (user_id,))
        events_clicked = cursor.fetchall()

        # Prepare response data
        clicked_events = []
        for event in events_clicked:
            event_data = {
                "event_id": event[0],
                "event_name": event[1],
                "start_date": event[2],  # Format date as string
                "end_date": event[3],  # Format date as string
                "event_category": event[4],
                "ticket_prices": event[5].split('-'),  # Convert ticket prices to list
                "url_photo": event[6],
                "description_text": event[7],
                "event_rules": event[8],
                "venue": {  # Nested dictionary for venue
                    "venue_name": event[9],
                    "address": event[10],
                    "url_photo": event[11]
                },
                "performer_name": event[12],
                "organizer_first_name": event[13], 
                "organizer_last_name": event[14]
            }
            clicked_events.append(event_data)

        # Close database connection
        cursor.close()
        connection.close()

        return jsonify({'clicked_events': clicked_events}), 200

    except Exception as e:
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500