import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticketify/general_widgets/page_selector/page_selector.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/Organizator/event/create_event_widget.dart';
import 'package:ticketify/pages/Organizator/organizer_homepage.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/admin/admin_create_report.dart';
import 'package:ticketify/pages/profile/widgets/profile_past_tickets.dart';

import '../../constants/constant_variables.dart';
import '../admin/admin_page.dart';

class ProfilePageBuyer extends StatefulWidget {
  const ProfilePageBuyer({super.key});

  @override
  State<ProfilePageBuyer> createState() => _ProfilePageBuyerState();
}

class _ProfilePageBuyerState extends State<ProfilePageBuyer> {
  String activePage = "ssssss";
  List<ProfileItemData> pastTickets = [];

  @override
  void initState() {
    super.initState();
    _viewPastTickets();
  }

  Future<void> _viewPastTickets() async {
    final String? token = await _getToken();

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/ticket/viewPastTickets'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> ticketsJson = jsonDecode(response.body);
      setState(() {
        pastTickets = ticketsJson.map((json) => ProfileItemData(
          title: json['event_name'],
          acceptDate: json['start_date'],
          location: json['venue_name'],
          organizer: "${json['organizer_first_name']} ${json['organizer_last_name']}",
          imageUrl: "https://picsum.photos/200/300", // Default image URL
        )).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tickets showed successfully')),
      );
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Past tickets couldn\'t be showed!');
    }
  }

  Future<String?> _getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'access_token');
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
          PageSelector(
            isCreateIssueEnabled: true,
            returnActivePageName: (newName) {
              setState(() {
                activePage = newName;
              });
            },
            title: "Profile",
            pageListConfigs: [
              PageListConfig(
                title: 'Tickets',
                menuItems: [
                  'Purchased Tickets',
                  'Upcoming Tickets',
                ],
                iconData: Icons.event,
              ),
            ], settingsPage: BuyerProfileSettings(),
          ),
          ProfileBrowseTickets(items: pastTickets),
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
  String? name;
  String? surname;
  String? user_type;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPassword2Controller = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> _fetchUserDetails() async {
    final String? token = await _getToken();

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/profile/get_user_details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userDetails = jsonDecode(response.body);
      setState(() {
        name = userDetails['first_name'];
        surname = userDetails['last_name'];
        user_type = userDetails['user_type'];
      });
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['error'] ?? 'Failed to fetch user details');
    }
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> _updateName() async{
    final String? token = await _getToken();
    final Map<String, dynamic> data = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
    };

    // Send the login request to your Flask backend
    final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/profile/change_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    // Handle the response from the backend
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name preferences saved successfully!')),
      );
      // Reload the current page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BuyerProfileSettings()),
      );
    } else {
      // Login failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Name change failed');
    }
  }
  Future<void> _changePassword() async{
    final String? token = await _getToken();
    final Map<String, dynamic> data = {
      'password_old': _oldPasswordController.text,
      'password_new1': _newPasswordController.text,
      'password_new2': _newPassword2Controller.text,
    };

    // Send the login request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/profile/change_password'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is changed successfully!')),
      );
    } else {
      // Login failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Password change unsaved!');
    }
  }
  List<ProfileItemData> pastTickets = [];

  @override
  void initState() {
    super.initState();
    _viewPastTickets();
    _fetchUserDetails();
  }

  Future<void> _viewPastTickets() async {
    final String? token = await _getToken();

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/ticket/viewPastTickets'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> ticketsJson = jsonDecode(response.body);
      setState(() {
        pastTickets = ticketsJson.map((json) => ProfileItemData(
          title: json['event_name'],
          acceptDate: json['start_date'],
          location: json['venue_name'],
          organizer: "${json['organizer_first_name']} ${json['organizer_last_name']}",
          imageUrl: "https://picsum.photos/200/300", // Default image URL
        )).toList();
      });
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Past tickets couldn\'t be showed!');
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
            title: "Welcome $name $surname",
            pageListConfigs: [
              PageListConfig(
                title: 'Tickets',
                menuItems: [
                  'Purchased Tickets',
                  'Upcoming Tickets',
                ],
                iconData: Icons.event,
              ),
            ], settingsPage: BuyerProfileSettings(),
          ),
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
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _oldPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Enter old password',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Enter new password',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _newPassword2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Renter new password',
                      ),
                    ),
                    ElevatedButton(
                      onPressed:_changePassword,
                      child: const Text('Change Password'),
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

class OrganizerProfileSettings extends StatefulWidget {
  const OrganizerProfileSettings({super.key});

  @override
  State<OrganizerProfileSettings> createState() => _OrganizerProfileSettingsState();
}

class _OrganizerProfileSettingsState extends State<OrganizerProfileSettings> {
  String activePage = "ssssss";
  String? name;
  String? surname;
  String? user_type;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPassword2Controller = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> _fetchUserDetails() async {
    final String? token = await _getToken();

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/profile/get_user_details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userDetails = jsonDecode(response.body);
      setState(() {
        name = userDetails['first_name'];
        surname = userDetails['last_name'];
        user_type = userDetails['user_type'];
      });
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['error'] ?? 'Failed to fetch user details');
    }
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> _updateName() async {
    final String? token = await _getToken();
    final Map<String, dynamic> data = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
    };

    // Send the request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/profile/change_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name preferences saved successfully!')),
      );
      // Reload the current page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrganizerProfileSettings()),
      );
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Name change failed');
    }
  }

  Future<void> _changePassword() async {
    final String? token = await _getToken();
    final Map<String, dynamic> data = {
      'password_old': _oldPasswordController.text,
      'password_new1': _newPasswordController.text,
      'password_new2': _newPassword2Controller.text,
    };

    // Send the request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/profile/change_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is changed successfully!')),
      );
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Password change unsaved!');
    }
  }

  List<ProfileItemData> pastTickets = [];

  @override
  void initState() {
    super.initState();
    //_viewPastTickets();
    //_fetchUserDetails();
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OrganizerHomepage()),
            );
          },
        ),
        title: const Text('Organizer Settings'),
        backgroundColor: AppColors.green.withOpacity(0.55),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children: [
            PageSelector(
              isCreateIssueEnabled: true,
              returnActivePageName: (newName) {
                setState(() {
                  activePage = newName;
                });
              },
              title: "Welcome $name $surname",
              pageListConfigs: [
                PageListConfig(
                  title: 'Tickets',
                  menuItems: [
                    'Purchased Tickets',
                    'Upcoming Tickets',
                  ],
                  iconData: Icons.event,
                ),
              ], settingsPage: OrganizerProfileSettings(),
            ),
          ]),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(37),
                color: AppColors.greylight.withAlpha(255),
              ),
              margin: const EdgeInsets.only(top: 50.0, bottom: 50, left: 20, right: 20),
              padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageTitle(title: "Account Settings"),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
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
                          onPressed: _updateName,
                          child: const Text('Save Name Preferences'),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _oldPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Enter old password',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Enter new password',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _newPassword2Controller,
                          decoration: const InputDecoration(
                            labelText: 'Re-enter new password',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _changePassword,
                          child: const Text('Change Password'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AdminProfileSettings extends StatefulWidget {
  const AdminProfileSettings({super.key});

  @override
  State<AdminProfileSettings> createState() => _AdminProfileSettingsState();
}

class _AdminProfileSettingsState extends State<AdminProfileSettings> {
  String activePage = "ssssss";
  String? name;
  String? surname;
  String? user_type;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPassword2Controller = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> _fetchUserDetails() async {
    final String? token = await _getToken();

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/profile/get_user_details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userDetails = jsonDecode(response.body);
      setState(() {
        name = userDetails['first_name'];
        surname = userDetails['last_name'];
        user_type = userDetails['user_type'];
      });
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['error'] ?? 'Failed to fetch user details');
    }
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> _updateName() async {
    final String? token = await _getToken();
    final Map<String, dynamic> data = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
    };

    // Send the request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/profile/change_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name preferences saved successfully!')),
      );
      // Reload the current page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminProfileSettings()),
      );
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Name change failed');
    }
  }

  Future<void> _changePassword() async {
    final String? token = await _getToken();
    final Map<String, dynamic> data = {
      'password_old': _oldPasswordController.text,
      'password_new1': _newPasswordController.text,
      'password_new2': _newPassword2Controller.text,
    };

    // Send the request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/profile/change_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is changed successfully!')),
      );
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Password change unsaved!');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminPage()),
            );
          },
        ),
        title: const Text('Admin Settings'),
        backgroundColor: AppColors.green.withOpacity(0.55),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children: [
            PageSelector(
              isCreateIssueEnabled: false,
              returnActivePageName: (newName) {
                setState(() {
                  activePage = newName;
                });
              },
              title: "Welcome $name $surname",
              pageListConfigs: [
              ], settingsPage: AdminProfileSettings(),
            ),
          ]),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(37),
                color: AppColors.greylight.withAlpha(255),
              ),
              margin: const EdgeInsets.only(top: 50.0, bottom: 50, left: 20, right: 20),
              padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageTitle(title: "Account Settings"),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
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
                          onPressed: _updateName,
                          child: const Text('Save Name Preferences'),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _oldPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Enter old password',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Enter new password',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _newPassword2Controller,
                          decoration: const InputDecoration(
                            labelText: 'Re-enter new password',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _changePassword,
                          child: const Text('Change Password'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
