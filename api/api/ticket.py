from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection
import math
import traceback
import uuid

ticket_bp = Blueprint('ticket', __name__, url_prefix='/ticket')

@ticket_bp.route('/chooseTicket', methods=['GET'])
def choose_ticket():   
    try:
        # Extract parameters from request
        data = request.json
        event_id = data.get('event_id')
        category_num = data.get('category_num')
        
        # Validate required parameters
        if not (event_id and category_num ):
            return jsonify({'error': 'Missing required parameters'}), 400

        category_num -= 1

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Fetch event details to get ticket prices
        cursor.execute("SELECT ticket_prices FROM event WHERE event_id = %s", (event_id,))
        event = cursor.fetchone()

        if not event:
            return jsonify({'error': 'Event does not exist'}), 404

        # Extract ticket prices and select the category price
        ticket_prices = event[0].split('-')
        if not (0 <= int(category_num) < len(ticket_prices)):
            return jsonify({'error': 'Invalid category number'}), 400

        category_price = int(ticket_prices[int(category_num)])

        # Fetch an available ticket for the event in the selected category
        query = """
            SELECT t.ticket_id, t.is_bought, t.ticket_barcode, t.ticket_price
            FROM tickets t
            INNER JOIN event_has_ticket eht ON t.ticket_id = eht.ticket_id
            WHERE eht.event_id = %s AND t.ticket_price = %s AND t.is_bought = FALSE
            ORDER BY t.ticket_id ASC
            LIMIT 1
        """
        cursor.execute(query, (event_id, category_price))
        ticket = cursor.fetchone()

        # Check if a suitable ticket is found
        if not ticket:
            return jsonify({'error': 'No available ticket found for the selected category'}), 404

        # Fetch seat information for the ticket
        cursor.execute("SELECT seat_position FROM ticket_seat WHERE ticket_id = %s", (ticket[0],))
        seat = cursor.fetchone()

        # Close database connection
        cursor.close()
        connection.close()

        if not seat[0]:
            return jsonify({'error': "server error no ticket seat"}), 500

        # Prepare response data
        ticket_info = {
            "ticket_id": ticket[0],
            "ticket_barcode": ticket[2],
            "ticket_price": ticket[3],
            "seat_position": seat[0]
        }

        return jsonify(ticket_info), 200

    except Exception as e:
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500


@ticket_bp.route('/buyTicket', methods=['POST'])
def buy_ticket():   
    # Extract parameters from request
    try:
        data = request.json
        user_id = data.get('user_id')
        ticket_ids = data.get('ticket_ids')
        event_id = data.get('event_id')

        # Validate required parameters
        if not (user_id and ticket_ids and event_id):
            return jsonify({'error': 'Missing required parameters'}), 400

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Check if the buyer exists and has sufficient funds
        cursor.execute("SELECT money FROM buyer WHERE user_id = %s", (user_id,))
        buyer = cursor.fetchone()
        if not buyer:
            return jsonify({'error': 'Buyer does not exist'}), 404

        buyer_money = buyer[0]
        # Calculate the total ticket price

        # Construct the SQL query with placeholders for each ticket ID
        query = """
            SELECT SUM(ticket_price)
            FROM tickets
            WHERE ticket_id IN ({}) AND is_bought = FALSE
        """.format(','.join(['%s'] * len(ticket_ids)))

        # Execute the SQL query with the ticket IDs as parameters
        cursor.execute(query, ticket_ids)
        
        total_price = cursor.fetchone()[0]

        if not total_price:
            return jsonify({'error': 'Invalid ticket IDs or tickets already bought'}), 400

        if buyer_money < total_price:
            return jsonify({'error': 'Insufficient funds'}), 400

        
        query = """
            UPDATE tickets
            SET is_bought = TRUE
            WHERE ticket_id IN ({})
        """.format(','.join(['%s'] * len(ticket_ids)))

        # Execute the SQL query with the ticket IDs as parameters
        cursor.execute(query, ticket_ids)

        # Create a payment record
        cursor.execute(
            "INSERT INTO Payment(amount) VALUES (%s)",
            (total_price,)
        )

        payment_id = cursor.lastrowid

        # Deduct the amount from the buyer's money
        cursor.execute(
            "UPDATE buyer SET money = money - %s WHERE user_id = %s",
            (total_price, user_id)
        )

        # Find the organizer id for the event
        cursor.execute(
            "SELECT user_id FROM organization_organize_event WHERE event_id = %s",
            (event_id,)
        )
        organizer = cursor.fetchone()
        if not organizer:
            return jsonify({'error': 'Organizer not found for the event'}), 404

        organizer_id = organizer[0]

        cursor.execute(
            "INSERT INTO buy (user_id, payment_id, organizer_id) VALUES (%s, %s, %s)",
            (user_id, payment_id, organizer_id)
        )
        
        # Insert records into the buy table for each ticket
        for ticket_id in ticket_ids:
            cursor.execute(
                "INSERT INTO payment_has_tickets (payment_id, ticket_id) VALUES (%s, %s)",
                (payment_id, ticket_id)
            )

        # Commit all changes
        connection.commit()

        # Close the database connection
        cursor.close()
        connection.close()

        return jsonify({'message': 'Tickets purchased successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e), 'trace': traceback.format_exc()}), 500
        