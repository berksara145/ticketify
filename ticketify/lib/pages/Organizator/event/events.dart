import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/objects/event_model.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/one_item_view.dart';
import 'package:http/http.dart' as http;


class EventsPage extends StatefulWidget {
  EventsPage({
    Key? key,
    this.filters = "empty",
    this.data,
  }) : super(key: key);

  final String? filters;
  final Map<String, dynamic>? data;

  @override
  _EventsPageState createState() => _EventsPageState();
}


class _EventsPageState extends State<EventsPage> {
  late Future<List<EventModel>>? _eventsFuture;
  //late List<EventModel> filteredEvents;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<List<EventModel>> _filterEvents() async {

    final String? token = await _getToken();

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/event/getFilteredEvents'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(widget.data),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      final List<dynamic> eventsData = jsonDecode(response.body);
      List<EventModel> filteredEvents = eventsData.map((event) {
        // Convert dynamic data to EventModel objects
        return EventModel.fromJson(event);
      }).toList();
      return filteredEvents;
    }else {
      // Handle error response
      throw Exception('Failed to load events');
    }
  }


  @override
  void initState() {
    super.initState();
    if (widget.data!['event_name'] == '' &&
        widget.data!['selected_categories'] is List &&
        widget.data!['selected_categories'].isEmpty &&
        widget.data!['start_date'] == null &&
        widget.data!['end_date'] == null &&
        widget.data!['min_price'] == 0 &&
        widget.data!['max_price'] == 10000000) {
      // Use the filtered events if provided
      _eventsFuture = UtilConstants().getAllEvents(context);

    } else {
      print('Filter Data: ${widget.data}');
      _eventsFuture = _filterEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(37),
          color: AppColors.greylight.withAlpha(255),
        ),
        margin:
            const EdgeInsets.only(top: 50.0, bottom: 50, left: 20, right: 20),
        padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageTitle(title: "Events"),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<EventModel>>(
                future: _eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final event = snapshot.data![index];
                        return InkWell(
                          onTap: () {
                            PostDTO post = PostDTO(
                              id: event.eventId.toString(),
                              tags: event.eventCategory!,
                              title: event.eventName!,
                              imageUrl: event.urlPhoto!,
                              sdate: DateTime.now(),
                              location: event.venue!.address!,
                              organizer: event.organizerFirstName!,
                              rules: event.eventRules!,
                              ticket_prices: event.ticketPrices!,
                              desc: event.descriptionText!,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OneItemView(
                                  post: post,
                                  event_id: event.eventId.toString(),
                                ),
                              ), // TODO: BURAYA GOROUTER
                            );
                          },
                          child: Card(
                            color: AppColors.greylight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      child: Image.network(
                                        event.urlPhoto ??
                                            "default_image_url", // Provide a default URL
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      event.eventName ?? "Unknown",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      event.venue?.venueName ??
                                          "No venue specified",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("No data available"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
