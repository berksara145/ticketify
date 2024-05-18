import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticketify/general_widgets/page_selector/page_selector.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/Organizator/event/create_event_widget.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/admin/admin_create_report.dart';
import 'package:ticketify/pages/profile/widgets/profile_past_tickets.dart';

import '../../constants/constant_variables.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //TODO: activePage logici ile gösterilecek sayfa seçilebilir.
  String activePage = "ssssss";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(),
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
                title: 'My Tickets',
                menuItems: [
                  'Past Tickets',
                  'Upcoming Tickets',
                  'Favoutite Venues',
                ],
                iconData: Icons.event,
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
          //AdminCreateReport()
          ProfileBrowseTickets()

//            Text(activePage)
        ],
      ),
    );
  }
}

class ProfilePageBuyer extends StatefulWidget {
  const ProfilePageBuyer({super.key});

  @override
  State<ProfilePageBuyer> createState() => _ProfilePageBuyerState();
}

class _ProfilePageBuyerState extends State<ProfilePageBuyer> {
  String activePage = "ssssss";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PageSelector(
            isCreateIssueEnabled: true,
            returnActivePageName: (newName) {
              setState(() {
                activePage = newName;
              });
            },
            title: "Welcome sssssssss",
            pageListConfigs: [
              PageListConfig(
                title: 'Tickets',
                menuItems: [
                  'Purchased Tickets',
                  'Upcoming Tickets',
                ],
                iconData: Icons.event,
              ),
            ],
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const BuyerProfileSettings()));
              },
              child: const Text(
                "Settings",
                style: TextStyle(color: AppColors.black),
              )),
          ProfileBrowseTickets()

//            Text(activePage)
        ],
      ),
    );
  }
}

class BuyerProfileSettings extends StatefulWidget {
  const BuyerProfileSettings({super.key});

  @override
  State<BuyerProfileSettings> createState() => _BuyerProfileSettingsState();
}

class _BuyerProfileSettingsState extends State<BuyerProfileSettings> {
  String activePage = "ssssss";
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<void> _updateName() async{
    final Map<String, dynamic> data = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
    };

    // Send the login request to your Flask backend
    final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/profile/change_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      // Successful login, navigate to homepage or perform other actions
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      String token = responseBody['access_token'];

      // Save the token securely
      await storage.write(key: 'access_token', value: token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name preferences saved successfully!')),
      );
    } else {
      // Login failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Name change failed');
    }
  }
  Future<void> _changePassword() async{
    final Map<String, dynamic> data = {
      'password': _passwordController.text,
    };

    // Send the login request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/profile/change_password'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      // Successful login, navigate to homepage or perform other actions
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      String token = responseBody['access_token'];

      // Save the token securely
      await storage.write(key: 'access_token', value: token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Last name is changed successfully!')),
      );
    } else {
      // Login failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Last name change failed');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children:[
          PageSelector(
            isCreateIssueEnabled: true,
            returnActivePageName: (newName) {
              setState(() {
                activePage = newName;
              });
            },
            title: "Welcome ",
            pageListConfigs: [
              PageListConfig(
                title: 'Tickets',
                menuItems: [
                  'Purchased Tickets',
                  'Upcoming Tickets',
                ],
                iconData: Icons.event,
              ),
            ],
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const BuyerProfileSettings()));
              },
              child: const Text(
                "Settings",
                style: TextStyle(color: AppColors.black),
              )),
      ]),
      Expanded(
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
              PageTitle(title: "Account Settings"),
              SizedBox(height: 20),
              Expanded(
                child: ListView(padding: const EdgeInsets.all(20),
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                    ),
                    ElevatedButton(
                      onPressed:_updateName,
                      child: const Text('Save Name Preferences'),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: const Text('Change Password'),
                      leading: const Icon(Icons.privacy_tip),
                      onTap: () {
                        // Navigate to privacy settings page
                      },
                    ),
                  ],),
              ),
            ],
          ),
        ),
      )
//            Text(activePage)
        ],
      ),
    );
  }
}