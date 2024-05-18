import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 4,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                        'https://picsum.photos/450/450'), // Placeholder image

                    Divider(),
                    Column(
                      children: [
                        Text('Event Details:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Artist: Dolu Kadehi Ters Tut'),
                        Text('Starts at: 20:00'),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle refund
                      },
                      child: Text('Refund Ticket'),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text('Dolu Kadehi Ters Tut'),
                        subtitle: Text('Concert'),
                      ),
                      Text('Date: 22 March 2020'),
                      Text('Type: Concert'),
                      SizedBox(height: 10),

                      // Add more details as needed
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('450 TL',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
