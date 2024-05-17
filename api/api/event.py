from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection
import math

event_bp = Blueprint('event', __name__, url_prefix='/event')


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
        VALUES (%s, %s, %s)
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
        venue_id = venue[0] 
        venue_name = venue[1] 
        section_count = venue[4]  # Assuming section_count is the 5th column (index 4)
        row_length = venue[6]  # Assuming venue_row_length is the 7th column (index 6)
        column_length = venue[7]  # Assuming venue_column_length is the 8th column (index 7)

        print(f"Venue ID: {venue_id}, Venue Name: {venue_name}, Section Count: {section_count}, Row Length: {row_length}, Column Length: {column_length}")

        # Calculate total seat count
        total_seats = row_length * column_length

        # Calculate the number of seats per section
        seats_per_section = total_seats // section_count

        # If there are any remaining seats after distributing evenly
        remaining_seats = total_seats % section_count

        #create tickets
        # Create a list to store the seat counts for each section
        #event_has_ticket event ticket bağla
        #ticket_seat ticket seat bağla ama seat kendin üret biliyon ztn çekmene gerek yok
        for i in range(section_count):
            for j in range(seats_per_section):
                seat_num = (i + 1) * seats_per_section + j + 1 #in total seat_num
                letter = math.ceil(seat_num / row_length) #gives seat letter
                num = (seat_num % row_length ) + 1 # gives seat num in row
                if(num == 1):
                    num = row_length

                ticket_id = create_tickets(event_id, ticket_prices[i], "")
                insert_ticket_seat_entry(ticket_id, str(chr(ord('A') + letter - 1)) + str(num))

        # Commit changes to the database
        connection.commit()

        # Close database connection
        cursor.close()
        connection.close()

        return jsonify({'message': 'Event created successfully', 'event_id': event_id}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

def insert_ticket_seat_entry(ticket_id, seat_position):
    try:
        # Connect to the MySQL database
        connection = get_db_connection()
        cursor = connection.cursor()

        print(f"Inserting entry into ticket_seat table with Ticket ID: {ticket_id}, Seat Position: {seat_position}")

        # SQL query to insert an entry into the ticket_seat table
        sql_query = "INSERT INTO ticket_seat (ticket_id, seat_position) VALUES (%s, %s)"
        
        # Tuple containing values to be inserted
        values = (ticket_id, seat_position)

        # Execute the SQL query
        cursor.execute(sql_query, values)
        connection.commit()
        
        print("Entry inserted into ticket_seat table successfully")

    except Exception as e:
        connection.rollback()
        print("Error inserting entry into ticket_seat table:", e)
        raise  # Re-raise the exception here

def create_tickets(event_id, ticket_price, barcode):
    try:
        # Connect to the MySQL database
        connection = get_db_connection()
        cursor = connection.cursor()

        print(f"Creating ticket for event ID: {event_id}, Ticket price: {ticket_price}, Barcode: {barcode}")
        is_bought = False  # By default, the ticket is not bought

        # Insert ticket data into the tickets table
        cursor.execute("INSERT INTO tickets (ticket_barcode, ticket_price, is_bought) VALUES (%s, %s, %s)",
                        (barcode, ticket_price, is_bought))
        ticket_id = cursor.lastrowid  # Get the ID of the newly inserted ticket

        print(f"Ticket {ticket_id} created successfully")

        # Create a relation between the event and the ticket
        cursor.execute("INSERT INTO event_has_ticket (event_id, ticket_id) VALUES (%s, %s)",
                        (event_id, ticket_id))
        
        # Commit changes to the database
        connection.commit()

        print(f"Ticket event added to the relation")

        # Close database connection
        cursor.close()
        connection.close()

        print(f"ticket created successfully and added to event {event_id}")
        return ticket_id
    except Exception as e:
        print("Error creating tickets:", e)
        raise
        
    finally:
        # Close the database connection
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("MySQL connection is closed")

        
