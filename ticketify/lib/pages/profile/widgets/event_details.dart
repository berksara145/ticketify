import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';

class EventDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Concert Ticket'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button
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
                borderRadius: BorderRadius.circular(37)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Dolu Kadehi Ters Tut',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Text('Date: 22 March 2020'),
                      Text('Type: Concert'),
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
                              child: Image.network(
                                  'https://picsum.photos/400/450'),
                            ),
                          ), // Placeholder image
                          SizedBox(
                            width: 100,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Event Details:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Artist: Dolu Kadehi Ters Tut'),
                              Text('Starts at: 20:00      Ends At: 000'),
                              Text('Location at: Ankara'),
                              Text('Organized by'),
                              Text(
                                'Event Info: Dolu Kadehi Ters Tut is getting ready to bring you its popular songs with the KerkiSolfej organization.',
                                softWrap: true,
                              ),
                              Text('Event Rules:'),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text('450 TL',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          // Handle refund
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
                              borderRadius: BorderRadius.circular(37)),
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
