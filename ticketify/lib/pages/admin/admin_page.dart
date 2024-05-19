import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/Organizator/event/create_event_widget.dart';
import 'package:ticketify/pages/Organizator/venue/venues.dart';
import 'package:ticketify/pages/admin/users/users.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/admin/admin_create_report.dart';
import 'package:ticketify/pages/profile/widgets/profile_past_tickets.dart';

import '../profile/profile_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  //TODO: activePage logici ile gösterilecek sayfa seçilebilir.
  String activePage = "View Venues";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PageSelector(
            isCreateIssueEnabled: false,
            returnActivePageName: (newName) {
              setState(() {
                activePage = newName;
              });
            },
            title: "Admin Account!",
            pageListConfigs: [
              PageListConfig(
                  title: 'Users',
                  menuItems: [
                    'View Users',
                    'Edit Users',
                  ],
                  iconData: Icons.person),
              PageListConfig(
                title: 'Venues',
                menuItems: [
                  'View Venues',
                  'Edit Venues',
                ],
                iconData: Icons.place,
              ),
              PageListConfig(
                title: 'Report',
                menuItems: [
                  'Create Report',
                ],
                iconData: Icons.data_saver_on_sharp,
              )
            ],
            settingsPage: AdminProfileSettings(),
          ),
          if (activePage == 'View Users') ...[UsersPage()],
          if (activePage == 'Edit Users') ...[
            CreateEventWidget(),
          ],
          if (activePage == 'View Venues') ...[VenuesPage()],
          if (activePage == 'Create Report') ...[
            AdminCreateReport(),
          ],

//            Text(activePage)
        ],
      ),
    );
  }
}
