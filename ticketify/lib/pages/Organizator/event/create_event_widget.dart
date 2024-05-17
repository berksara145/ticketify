import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
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
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      hintText: "Select type of the event",
                      initialSelection: "",
                      dropdownMenuEntries: eventType.map((category) {
                        return DropdownMenuEntry<String>(
                          value: category,
                          label: category,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _eventName = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Name of the Event',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10.0),
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
                                    const Icon(Icons.calendar_month_outlined),
                                    Text(
                                        'Select Date: ${_formatDate(_startDate)}'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
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
                                    const Icon(Icons.access_time),
                                    Text(
                                        'Start Time: ${_formatTime(_startTime)}'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
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
                                    const Icon(Icons.access_time),
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
                                        final selectedDate =
                                            await showDatePicker(
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
                                          const Icon(
                                              Icons.calendar_month_outlined),
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
                                        final selectedDate =
                                            await showDatePicker(
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
                                          const Icon(
                                              Icons.calendar_month_outlined),
                                          Text(
                                              'End Date: ${_formatDate(_endDate)}'),
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
                                        final selectedTime =
                                            await showTimePicker(
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
                                        final selectedTime =
                                            await showTimePicker(
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
                                          Text(
                                              'End Time: ${_formatTime(_endTime)}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Checkbox(
                          fillColor:
                              MaterialStateProperty.all(Colors.transparent),
                          checkColor: Colors.black,
                          value: _isOneDayEvent,
                          onChanged: (value) {
                            setState(() {
                              _isOneDayEvent = value!;
                            });
                          },
                        ),
                        const Text('1 Day Event'),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    DropdownMenu<String>(
                      expandedInsets: const EdgeInsets.all(0),
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
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownMenu<String>(
                        expandedInsets: const EdgeInsets.all(0),
                        hintText: items.isEmpty
                            ? "Select Venue First"
                            : "Select Category",
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
                    const SizedBox(height: 10.0),
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
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText: 'Brief Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                eventRules = value;
                              });
                            },
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText: "Event Rules",
                              //     labelText: 'Event Rules',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // Upload photo logic here
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            child: const Row(
                              children: [
                                Text('Upload Photo'),
                                Icon(Icons.photo)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
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
                  ],
                ),
              ),
            ],
          ),
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
