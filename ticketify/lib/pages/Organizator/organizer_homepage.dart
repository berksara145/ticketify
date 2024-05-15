import 'package:flutter/material.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector.dart';
import 'package:ticketify/pages/Organizator/event/create_event_widget.dart';
import 'package:ticketify/pages/Organizator/event/create_venue_widget.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/profile/profile_page.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  String page = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PageSelector(
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
          if (page == "Create Event") ...[
            CreateEventWidget(),
          ],
          if (page == "Create Venue") ...[CreateVenueWidget()]
        ],
      ),
    );
  }
}
