import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/objects/issue.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:http/http.dart' as http;

class IssueListPage extends StatefulWidget {
  @override
  _IssueListPageState createState() => _IssueListPageState();
}

class _IssueListPageState extends State<IssueListPage> {

  late List<Issue> issues ;

  TextEditingController textController = TextEditingController();
  Issue? selectedIssue;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> createIssueResponse( String responseText) async {
    try {
      final String? token = await getToken();
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/response/createIssueResponse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'issue_id': selectedIssue!.id,
          'response_text': responseText,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue response created successfully!')),
        );
        // Optionally, you can update the UI or perform any other action here
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create issue response!')),
        );
        print('Failed to create issue response. Status code: ${response.statusCode}');
        // Handle error or display a message to the user
      }
    } catch (e) {
      print('Error while creating issue response: $e');
      // Handle error or display a message to the user
    }
  }

  Future<List<Issue>> browseIssues() async {
    try {
      final String? token = await getToken();
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/issue/browseIssues'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        List<Issue> issuesList = jsonData
            .map<Issue>((json) => Issue.fromJson(json))
            .toList();
        return issuesList;
      } else {
        print('Failed to fetch issues. Status code: ${response.statusCode}');
        return []; // Return an empty list if failed to fetch issues
      }
    } catch (e) {
      print('Error occurred while fetching issues: $e');
      return []; // Return an empty list if an error occurred
    }
  }

  @override
  void initState() {
    super.initState();
    fetchIssues();
  }

  Future<void> fetchIssues() async {
    List<Issue> fetchedIssues = await browseIssues();
    setState(() {
      issues = fetchedIssues;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Sort issues so solved issues are at the bottom
    issues.sort((a, b) {
      if (a.isSolved && !b.isSolved) return 1;
      if (!a.isSolved && b.isSolved) return -1;
      return 0;
    });

    return Scaffold(
      appBar: WBAppBar(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.greylight,
              borderRadius: BorderRadius.circular(37)),
          height: height - 300,
          width: width - 500,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: selectedIssue == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Current issues",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: issues.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(issues[index].title),
                              trailing: issues[index].isSolved
                                  ? Icon(Icons.check, color: Colors.green)
                                  : Icon(Icons.error, color: Colors.red),
                              onTap: () {
                                setState(() {
                                  selectedIssue = issues[index];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              setState(() {
                                selectedIssue = null;
                              });
                            },
                          ),
                          Text(
                            selectedIssue!.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        selectedIssue!.details,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Responses:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: selectedIssue!.responses.isEmpty
                            ? Text('No responses yet.')
                            : ListView.builder(
                                itemCount: selectedIssue!.responses.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title:
                                        Text(selectedIssue!.responses[index]),
                                  );
                                },
                              ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textController,
                              decoration: const InputDecoration(
                                labelText: 'Add your response',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                setState(() {
                                  createIssueResponse(textController.text);
                                  selectedIssue!.responses
                                      .add(textController.text);
                                  textController.clear();
                                });
                              }
                            },
                            icon: Icon(Icons.send),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
