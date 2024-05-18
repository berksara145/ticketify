import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector_title.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../homepage/homepage.dart';

class CreateIssue extends StatefulWidget {
  const CreateIssue({Key? key}) : super(key: key);

  @override
  State<CreateIssue> createState() => _CreateIssueState();
}

class _CreateIssueState extends State<CreateIssue> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }
  Future<void> _createIssue() async {
    // Construct the login request payload
    final String? token = await _getToken();
    final Map<String, dynamic> data = {
      'issue_text': _titleController.text,
      'issue_name': _descriptionController.text,
    };

    // Send the login request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/issue/createIssue'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      // Successful login, navigate to homepage or perform other actions
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    }
     else {
      // Login failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Issue create failed');
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(50),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
                color: AppColors.greylight.withAlpha(255),
                borderRadius: BorderRadius.circular(37),
              ),
              width: 400,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PageSelectorTitle(title: "Create Issue"),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.wheelchair_pickup),
                            SizedBox(width: 8),
                            Text(
                              "Always be kind",
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.wheelchair_pickup),
                            SizedBox(width: 8),
                            Text(
                              "Be clear and precise",
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.wheelchair_pickup),
                            SizedBox(width: 8),
                            Text(
                              "Be realistic in your issues",
                              style: TextStyle(fontSize: 24),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      color: AppColors.greylight.withAlpha(255),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Issue Title"),
                          SizedBox(height: 8),
                          TextField(
                            maxLength: 40,
                            minLines: 1,
                            maxLines: 5,
                            controller: _titleController,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: AppColors.greylight.withAlpha(255),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 4), // Shadow position
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Issue Description"),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(37)),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  minLines: null,
                                  maxLines: null,
                                  expands: true,
                                  controller: _descriptionController,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: InkWell(
                      onTap: _createIssue,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 1),
                        ),
                        child: Text("Create issue"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}
