import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String activePage = "ssssss";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.0), // Adjust the horizontal padding as needed
        child: Row(
          children: [
            PageSelector(
              returnActivePageName: (newName) {
                setState(() {
                  activePage = newName;
                });
              },
              title: "Memduh Tutuş Welcome back!",
              pageListConfigs: [
                PageListConfig(
                  title: 'Events',
                  menuItems: [
                    'Past Events',
                    'Upcoming Events',
                    'Create Event',
                  ],
                  iconData: Icons.event,
                ),
                PageListConfig(
                  title: 'Venues',
                  menuItems: [
                    'Create',
                    'Delete Event',
                  ],
                  iconData: Icons.place,
                ),
              ],
            ),
            Text(activePage)
          ],
        ),
      ),
    );
  }
}
