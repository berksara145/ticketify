import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/homepage/display_products_components.dart';

class AdminCreateReport extends StatefulWidget {
  @override
  _AdminCreateReportState createState() => _AdminCreateReportState();
}

class _AdminCreateReportState extends State<AdminCreateReport> {
  String _selectedEventType = 'Concert';
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

  List<String> venues = ['Venue A', 'Venue B', 'Venue C'];
  Map<String, List<String>> venueCategories = {
    'Venue A': ['Category 1', 'Category 2'],
    'Venue B': ['Category 3', 'Category 4'],
    'Venue C': ['Category 5', 'Category 6'],
  };
  String dropdownValue = "";
  List<String> eventType = ['concert', 'opera', 'comedy', 'theater'];

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
              const PageTitle(title: "Create Event"),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  children: [
                    DropdownMenu<String>(
                      expandedInsets: EdgeInsets.all(0),
                      hintText: "Select organizer",
                      initialSelection: "",
                      dropdownMenuEntries: eventType.map((category) {
                        return DropdownMenuEntry<String>(
                          value: category,
                          label: category,
                        );
                      }).toList(),
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
                    Column(
                      children: [
                        DropdownMenu<String>(
                          enabled: _isOneVenue,
                          expandedInsets: const EdgeInsets.all(0),
                          hintText: "Select Venue (optional)",
                          onSelected: (String? color) {
                            setState(() {
                              selectedVenue = color;
                              items = venueCategories[selectedVenue]!;
                            });
                          },
                          controller: selectVenueController,
                          dropdownMenuEntries: venues
                              .map<DropdownMenuEntry<String>>((String color) {
                            return DropdownMenuEntry<String>(
                              value: color,
                              label: color,
                            );
                          }).toList(),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              fillColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              checkColor: Colors.black,
                              value: _isOneVenue,
                              onChanged: (value) {
                                setState(() {
                                  _isOneVenue = value!;
                                });
                              },
                            ),
                            const Text('Only Search For a Spesific Venue'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(_generateReportSummary()),
                    InkWell(
                      onTap: () {
                        // Create event logic here
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
    return "This will create a report containing statistics of ticket sales, attendances, and earnings for $_selectedEventType events from ${_formatDate(_startDate)} to ${_formatDate(_endDate)} between ${_formatTime(_startTime)} and ${_formatTime(_endTime)} at $venueString.";
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(TimeOfDay time) {
    return time.format(context);
  }
}
