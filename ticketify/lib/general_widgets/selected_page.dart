import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/homepage/display_products_components.dart';

class CreateEventWidget extends StatefulWidget {
  @override
  _CreateEventWidgetState createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  String _selectedEventType = 'Concert';
  String _eventName = '';
  bool _isOneDayEvent = true;
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
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(25),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(37),
          color: AppColors.greylight.withAlpha(255),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.5),
              blurRadius: 4,
              offset: Offset(0, 4), // Shadow position
            ),
          ],
        ),
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.greydark,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Create Event',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            DropdownMenu<String>(
              expandedInsets: EdgeInsets.all(0),
              hintText: "Select type of the event",
              initialSelection: "",
              dropdownMenuEntries: eventType.map((category) {
                return DropdownMenuEntry<String>(
                  value: category,
                  label: category,
                );
              }).toList(),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _eventName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter Name of the Event',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            _isOneDayEvent
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
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
                            Icon(Icons.calendar_month_outlined),
                            Text('Select Date: ${_formatDate(_startDate)}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      InkWell(
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
                            Icon(Icons.access_time),
                            Text('Start Time: ${_formatTime(_startTime)}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      InkWell(
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
                            Icon(Icons.access_time),
                            Text('End Time: ${_formatTime(_endTime)}'),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
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
                                  Icon(Icons.calendar_month_outlined),
                                  Text(
                                      'Start Date: ${_formatDate(_startDate)}'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
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
                                  Icon(Icons.calendar_month_outlined),
                                  Text('End Date: ${_formatDate(_endDate)}'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
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
                                  Icon(Icons.access_time),
                                  Text(
                                      'Start Time: ${_formatTime(_startTime)}'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
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
                                  Icon(Icons.access_time),
                                  Text('End Time: ${_formatTime(_endTime)}'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Checkbox(
                  fillColor: MaterialStateProperty.all(Colors.transparent),
                  checkColor: Colors.black,
                  value: _isOneDayEvent,
                  onChanged: (value) {
                    setState(() {
                      _isOneDayEvent = value!;
                    });
                  },
                ),
                Text('1 Day Event'),
              ],
            ),
            SizedBox(height: 10.0),
            DropdownMenu<String>(
              expandedInsets: EdgeInsets.all(0),
              hintText: "Select Venue",
              onSelected: (String? color) {
                setState(() {
                  selectedVenue = color;
                  items = venueCategories[selectedVenue]!;
                });
              },
              controller: selectVenueController,
              dropdownMenuEntries:
                  venues.map<DropdownMenuEntry<String>>((String color) {
                return DropdownMenuEntry<String>(
                  value: color,
                  label: color,
                );
              }).toList(),
            ),
            SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: DropdownMenu<String>(
                expandedInsets: EdgeInsets.all(0),
                hintText:
                    items.isEmpty ? "Select Venue First" : "Select Category",
                dropdownMenuEntries: items.isEmpty
                    ? []
                    : venueCategories[selectedVenue]!.map((category) {
                        return DropdownMenuEntry<String>(
                          value: category,
                          label: category,
                        );
                      }).toList(),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        briefDescription = value;
                      });
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Brief Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        eventRules = value;
                      });
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Event Rules',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    // Upload photo logic here
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Row(
                      children: [Text('Upload Photo'), Icon(Icons.photo)],
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                InkWell(
                  onTap: () {
                    // Create event logic here
                  },
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      padding: EdgeInsets.all(5),
                      child: Text('Create')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _formatTime(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
