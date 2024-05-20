import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/objects/venue_model.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'package:ticketify/pages/homepage/purchase_ticket.dart';

class VenueOneItemView extends StatefulWidget {
  VenueOneItemView({
    Key? key,
    this.venue,
    this.event_id = "0",
  }) : super(key: key);

  final Venue? venue;
  final String event_id;
  @override
  State<VenueOneItemView> createState() => _VenueOneItemViewState();
}

class _VenueOneItemViewState extends State<VenueOneItemView> {
  late Venue venue;
  late String event_id;
  @override
  void initState() {
    super.initState();
    venue = widget.venue!;
    event_id = widget.event_id;
  }

  @override
  Widget build(BuildContext context) {
    return DesktopVenueOneItemView(
      venue: venue,
      widget: widget,
      event_id: event_id,
    );
  }
}

class DesktopVenueOneItemView extends StatelessWidget {
  DesktopVenueOneItemView({
    super.key,
    this.venue,
    required this.event_id,
    required this.widget,
  });

  Venue? venue;
  final VenueOneItemView widget;
  final String event_id;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? address;
    String? phoneNo;
    List<Seats>? seats;
    String? urlPhoto;
    int? venueColumnLength;
    int? venueId;
    String? venueName;
    int? venueRowLength;
    int? venueSectionCount;

    return Scaffold(
      appBar: UserAppBar(),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Container(
          height: height - 150,
          decoration: BoxDecoration(
            color: AppColors.secondBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 40),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios_sharp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            venue!.venueName!,
                            style: TextStyle(fontSize: 52),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            widget.venue?.urlPhoto ??
                                "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg",
                            fit: BoxFit.cover,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Venue Details",
                                      style: TextStyle(fontSize: 36),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                                "Contact Number: ${venue?.phoneNo}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                                "Location: ${venue?.address}"),
                                          ),
                                          Text(
                                            "Capacity:  ${venue!.venueRowLength! * venue!.venueColumnLength!}",
                                            softWrap:
                                                true, // Allow text to wrap to multiple lines
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                              "Number of Sections: ${venue?.venueSectionCount} ",
                                              softWrap:
                                                  true, // Allow text to wrap to multiple lines
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
                        ],
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
