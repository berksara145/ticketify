import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/Organizator/event/create_event_widget.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/admin/admin_create_report.dart';
import 'package:ticketify/pages/profile/widgets/profile_past_tickets.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  //TODO: activePage logici ile gösterilecek sayfa seçilebilir.
  String activePage = "ssssss";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PageSelector(
            isCreateIssueEnabled: true,
            returnActivePageName: (newName) {
              setState(() {
                activePage = newName;
              });
            },
            title: "Memduh Tutuş Welcome back!sssssssss",
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
                title: 'Settings',
                menuItems: [
                  'Profile Info',
                  'Change Password',
                ],
                iconData: Icons.place,
              ),
            ],
          ),
          AdminCreateReport()

//            Text(activePage)
        ],
      ),
    );
  }
}
