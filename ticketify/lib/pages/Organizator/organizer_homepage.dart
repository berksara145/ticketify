import 'package:flutter/material.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector.dart';
import 'package:ticketify/pages/Organizator/event/create_event_widget.dart';
import 'package:ticketify/pages/Organizator/event/events.dart';
import 'package:ticketify/pages/Organizator/venue/create_venue_widget.dart';
import 'package:ticketify/pages/Organizator/venue/venues.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/profile/profile_page.dart';

import '../../constants/constant_variables.dart';
import '../../objects/event_model.dart';

class OrganizerHomepage extends StatefulWidget {
  const OrganizerHomepage({super.key});

  @override
  State<OrganizerHomepage> createState() => _OrganizerHomepageState();
}

class _OrganizerHomepageState extends State<OrganizerHomepage> {
  String page = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrganizerAppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: PageSelector(
                pageListConfigs: [
                  PageListConfig(
                      title: "Events",
                      menuItems: [
                        'Past Events',
                        'Upcoming Events',
                        'Create Event',
                      ],
                      iconData: Icons.event),
                  PageListConfig(
                      title: "Venues",
                      menuItems: ["Venues", "Create Venue"],
                      iconData: Icons.place)
                ],
                title: "Organizer, Welcome Back",
                returnActivePageName: (name) {
                  setState(() {
                    page = name;
                  });
                }, settingsPage: OrganizerProfileSettings(),),
          ),
          if (page == "Upcoming Events") ...[

          ],
          if (page == "Create Event") ...[
            CreateEventWidget(),
          ],
          if (page == "Create Venue") ...[CreateVenueWidget()],
          if (page == "Venues") ...[VenuesPage()],
        ],
      ),
    );
  }
}
