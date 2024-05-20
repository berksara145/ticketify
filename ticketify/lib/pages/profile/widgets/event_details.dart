import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/profile/profile_page.dart';
import 'package:ticketify/pages/profile/widgets/profile_past_tickets.dart'; // Import the ProfileItemData class

class EventDetails extends StatelessWidget {
  final ProfileItemData event;


  const EventDetails({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Event Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
              color: AppColors.greylight.withAlpha(255),
              borderRadius: BorderRadius.circular(37),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          event.title,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Text('Date: ${event.acceptDate}'),
                      Text('Location: ${event.location}'),
                      Text('Organizer: ${event.organizer}'),
                      SizedBox(height: 10),
                      // Add more details as needed
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 400,
                            width: 400,
                            child: FittedBox(
                              child: Image.network('https://picsum.photos/200/300'),
                            ),
                          ),
                          SizedBox(width: 100),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Event Details:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              // Display additional event details if needed
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text('450 TL',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          // Handle refund
                          UtilConstants utilConstants = UtilConstants();
                          utilConstants.refundTicket(context, event.ticket_id);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfilePageBuyer()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.5),
                                blurRadius: 1,
                                offset: Offset(0, 1), // Shadow position
                              ),
                            ],
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(37),
                          ),
                          child: Text('Refund Ticket'),
                          padding: EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
