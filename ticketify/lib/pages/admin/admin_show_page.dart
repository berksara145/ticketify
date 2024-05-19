import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowReportPage extends StatefulWidget {
  @override
  _ShowReportPageState createState() => _ShowReportPageState();
}

class _ShowReportPageState extends State<ShowReportPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    _fetchReports();
    super.initState();
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> _fetchReports() async {
    final String? token = await _getToken();
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/report/getReports'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

  if (response.statusCode == 200) {
      final List<dynamic> fetchedReports = jsonDecode(response.body);
      setState(() {
        reports = List<Map<String, dynamic>>.from(fetchedReports);
      });
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['error'] ?? 'Failed to fetch reports');
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
      appBar: AppBar(
        title: Text('Report Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generated Reports',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              ...reports.map((report) => ReportCard(report: report)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;

  ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organizer ID: ${report['organizer_id']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Event ID: ${report['event_id']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total Revenue: \$${report['total_revenue']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Start date: \$${report['start_date']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'End date: \$${report['end_date']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Creation date: \$${report['created_at']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
