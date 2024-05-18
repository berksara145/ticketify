import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';

class IssueListPage extends StatefulWidget {
  @override
  _IssueListPageState createState() => _IssueListPageState();
}

class _IssueListPageState extends State<IssueListPage> {
  final List<Issue> issues = [
    Issue(title: 'Issue 1', details: 'Details of issue 1'),
    Issue(title: 'Issue 2', details: 'Details of issue 2'),
    Issue(title: 'Issue 3', details: 'Details of issue 3'),
    // Add more issues here
  ];

  TextEditingController textController = TextEditingController();
  Issue? selectedIssue;

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
      appBar: UserAppBar(),
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
                              decoration: InputDecoration(
                                labelText: 'Add your response',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                setState(() {
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

class Issue {
  final String title;
  final String details;
  List<String> responses;

  Issue({
    required this.title,
    required this.details,
    List<String>? responses,
  }) : responses = responses ?? [];

  bool get isSolved => responses.isNotEmpty;
}
