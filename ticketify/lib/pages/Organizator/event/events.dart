import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/objects/event_model.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/one_item_view.dart';
import 'package:http/http.dart' as http;

class EventsPage extends StatefulWidget {
  EventsPage({
    Key? key,
    required this.eventsFuture,
  }) : super(key: key);

  final Future<List<EventModel>> eventsFuture;

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  //late Future<List<EventModel>>? _eventsFuture;
  //late List<EventModel> filteredEvents;

  @override
  void initState() {
    super.initState();
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
                future: widget.eventsFuture,
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
                                  event: event,
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
                                    Text(
                                      event.startDate ?? "No time ",
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
