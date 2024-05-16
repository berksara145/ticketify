import 'package:flutter/material.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector.dart';
import 'package:ticketify/objects/venue.dart';
import 'package:ticketify/pages/Organizator/event/create_event_widget.dart';
import 'package:ticketify/pages/Organizator/venue/create_venue_widget.dart';
import 'package:ticketify/pages/Organizator/venue/venues.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/profile/profile_page.dart';

class OrganizerHomepage extends StatefulWidget {
  const OrganizerHomepage({super.key});

  @override
  State<OrganizerHomepage> createState() => _OrganizerHomepageState();
}

class _OrganizerHomepageState extends State<OrganizerHomepage> {
  String page = "";
  List<Venue> venues = [
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 1',
      address: '123 Main St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Venue(
      name: 'Venue 2',
      address: '456 Elm St',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    // Add more venues as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(),
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
                }),
          ),
          if (page == "Create Event") ...[
            CreateEventWidget(),
          ],
          if (page == "Create Venue") ...[CreateVenueWidget()],
          if (page == "Venues") ...[
            VenuesPage(
              venues: venues,
            )
          ],
        ],
      ),
    );
  }
}
