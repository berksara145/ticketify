from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection
import math
import traceback


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
        

        return jsonify(event_list), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# burada ticket logici çözülmeli daha yapmadım bide sqlde de table değişcek
@event_bp.route('/createEvent', methods=['POST'])
def create_event():
    try:
        print("entered create event")
        # Extract data from request
        data = request.json
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
        ticket_prices = data.get('ticket_prices')  # Array of ticket prices)

        # Validate required data
        if not ( event_name and start_date and end_date and event_category
                and event_image and description_text and event_rules and organizer_id and venue_id 
                and ticket_prices and performer_name):
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
        

        
@event_bp.route('/getFilteredEvents', methods=['GET'])
def get_filtered_events():
    try:
        print("entered get all filtered events")

        
    except Exception as e:
        return jsonify({'error': str(e)}), 500



@event_bp.route('/addEventClicked', methods=['POST'])
def add_event_clicked():
    try:
        print("entered get all filtered events")

        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

    
@event_bp.route('/getEventsClicked', methods=['GET'])
def add_event_clicked():
    try:
        print("entered get all filtered events")

        
    except Exception as e:
        return jsonify({'error': str(e)}), 500