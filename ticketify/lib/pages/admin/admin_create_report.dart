import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/homepage/display_products_components.dart';
import 'package:ticketify/pages/admin/admin_show_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class AdminCreateReport extends StatefulWidget {
  @override
  _AdminCreateReportState createState() => _AdminCreateReportState();
}

class _AdminCreateReportState extends State<AdminCreateReport> {
  String _selectedOrgType = "";
  String _eventName = '';
  bool _isOneVenue = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String? selectedVenue = '';
  String? selectedCategory = '';
  String briefDescription = '';
  String eventRules = '';
  List<String> items = [];
  final TextEditingController selectVenueController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  List<String> venues = ['Venue A', 'Venue B', 'Venue C'];
  Map<String, List<String>> venueCategories = {
    'Venue A': ['Category 1', 'Category 2'],
    'Venue B': ['Category 3', 'Category 4'],
    'Venue C': ['Category 5', 'Category 6'],
  };
  String dropdownValue = "";
  List<String> eventType = ['concert', 'opera', 'comedy', 'theater'];
  List<String> organizers = [];
  List<int> organizersId = [];

  @override
  void initState() {
    super.initState();
    _fetchOrganizers();
  }

  Future<String?> _getToken() async {
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

  Future<void> _fetchOrganizers() async {
    final String? token = await _getToken();

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/report/getOrganizers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> fetchedOrganizers = jsonDecode(response.body);
      setState(() {
        organizers = fetchedOrganizers.map((organizer) => organizer['name'].toString()).toList();
        organizersId = fetchedOrganizers.map((organizer) => organizer['user_id'] as int ).toList();
      });
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['error'] ?? 'Failed to fetch organizers');
    }
  }

  Future<void> _createReport() async {
  final String? token = await _getToken();

  // Extracting the selected organizer ID
  String selectedOrganizer = _selectedOrgType;
  int organizerId = organizersId[organizers.indexOf(selectedOrganizer)];

  // Make a POST request to the backend endpoint
  final response = await http.post(
    Uri.parse('http://localhost:5000/report/createReport'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'start_date': _formatDate(_startDate),
      'end_date': _formatDate(_endDate),
      'organizer_id': organizerId,
    }),
  );

  if (response.statusCode == 200) {
    // Navigate to a new page
    // Parse the response body
    final dynamic responseBody = jsonDecode(response.body);
    final List<Map<String, dynamic>> reportData = List<Map<String, dynamic>>.from(responseBody);
    
    // Navigate to the ShowReportPage with the report data
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowReportPage(reportData: reportData)),
    );
  } else {
    // Handle error if the request fails
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    _showErrorDialog(responseBody['error'] ?? 'Failed to create report');
  }
}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(50),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PageTitle(title: "Create Report for Organizer"),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  children: [
                    DropdownMenu<String>(
                      expandedInsets: EdgeInsets.all(0),
                      hintText: "Select organizer",
                      initialSelection: "",
                      dropdownMenuEntries: organizers.map((organizer) {
                        return DropdownMenuEntry<String>(
                          value: organizer,
                          label: organizer,
                        );
                      }).toList(),
                      onSelected: (String? selectedOrganizer) {
                        setState(() {
                          _selectedOrgType = selectedOrganizer ?? ''; // Update the selected organizer

                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: _startDate,
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2025),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      _startDate = selectedDate;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined),
                                    Text(
                                        'Start Date: ${_formatDate(_startDate)}'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: _endDate,
                                    firstDate: _startDate,
                                    lastDate: DateTime(2025),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      _endDate = selectedDate;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined),
                                    Text('End Date: ${_formatDate(_endDate)}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: _startTime,
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      _startTime = selectedTime;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time),
                                    Text(
                                        'Start Time: ${_formatTime(_startTime)}'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: _endTime,
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      _endTime = selectedTime;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time),
                                    Text('End Time: ${_formatTime(_endTime)}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const SizedBox(height: 10.0),
                    Text(_generateReportSummary()),
                    InkWell(
                      onTap: () {
                        // Call the _createReport method when the "Create" button is tapped
                        _createReport();
                      },
                      child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          padding: const EdgeInsets.all(5),
                          child: const Text('Create')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _generateReportSummary() {
    String venueString =
        _isOneVenue && selectedVenue != null ? selectedVenue! : "any venue";
    return "This will create a report containing statistics of ticket sales, attendances, and earnings from ${_formatDate(_startDate)} to ${_formatDate(_endDate)} between ${_formatTime(_startTime)} and ${_formatTime(_endTime)} at $venueString.";
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(TimeOfDay time) {
    return time.format(context);
  }
}
