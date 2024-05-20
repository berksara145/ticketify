import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/objects/venue_model.dart';
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
  Venue? selectedVenue;
  String? selectedCategory = '';
  String briefDescription = '';
  String eventRules = '';
  List<String?> categories = [];
  List<TextEditingController> controllers = [];

  int? noofsections = 0;
  VenueModel? venueModel;
  List<String> eventType = ['concert', 'opera', 'comedy', 'theater'];

  @override
  void initState() {
    super.initState();
    loadVenues();
  }

  Future<void> loadVenues() async {
    var fetchedVenues = await UtilConstants()
        .getAllVenues(context); // Make sure this returns VenueModel
    setState(() {
      venueModel = fetchedVenues;
    });
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
              const PageTitle(title: "Create Event"),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  children: [
                    DropdownMenu<String>(
                      expandedInsets: const EdgeInsets.all(0),
                      hintText: "Select type of the event",
                      initialSelection: _selectedEventType,
                      dropdownMenuEntries: eventType.map((String type) {
                        return DropdownMenuEntry<String>(
                          value: type,
                          label: type.toUpperCase(),
                        );
                      }).toList(),
                      onSelected: (String? type) {
                        setState(() {
                          _selectedEventType = type!;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: _eventName,
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
                    Row(
                      children: [
                        Checkbox(
                          fillColor:
                              MaterialStateProperty.all(Colors.transparent),
                          checkColor: Colors.black,
                          value: _isOneDayEvent,
                          onChanged: (bool? value) {
                            setState(() {
                              _isOneDayEvent = value!;
                              if (value) {
                                _endDate = _startDate;
                              }
                            });
                          },
                        ),
                        const Text('1 Day Event'),
                      ],
                    ),
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
                                      _endDate = selectedDate;
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
                    // Additional Widgets for date and time selection, venue, and category selection
                    DropdownMenu<Venue>(
                      expandedInsets: const EdgeInsets.all(0),
                      hintText: "Select Venue",
                      onSelected: (Venue? venue) {
                        setState(() {
                          selectedVenue =
                              venue; /*
                          categories = venue?.seats // BURAYI DEĞİŞTİRYORUM 
                                  ?.map((seat) => seat.seatPosition)
                                  .toList() ??
                              [];
                        */
                          noofsections = venue?.venueSectionCount;
                          // Dispose existing controllers
                          for (var controller in controllers) {
                            controller.dispose();
                          }

                          // Initialize new controllers based on the new number of sections
                          controllers = List.generate(noofsections ?? 0,
                              (index) => TextEditingController());

                          print("noofsections $noofsections");
                        });
                      },
                      dropdownMenuEntries: venueModel?.venues?.map((venue) {
                            return DropdownMenuEntry<Venue>(
                              value: venue,
                              label: venue.venueName ?? 'Unknown Venue',
                            );
                          }).toList() ??
                          [],
                    ),
                    const SizedBox(height: 10.0),
                    noofsections != null && noofsections! > 0
                        ? Container(
                            height: 250,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    3, // Adjust the number of columns as needed
                                childAspectRatio:
                                    2.0, // Adjust the aspect ratio as needed
                              ),
                              itemCount: noofsections!,
                              itemBuilder: (context, index) {
                                return TextField(
                                  controller: controllers[index],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Section ${index + 1}',
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              'Select Venue First',
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
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
                            List<int> sectionPrices = List.generate(
                                controllers.length,
                                (index) => int.parse(controllers[index].text));

                            UtilConstants().createEvent(
                                context,
                                _eventName,
                                _startDate.toString(),
                                _endDate.toString(),
                                _selectedEventType,
                                "https://picsum.photos/200/300",
                                briefDescription,
                                eventRules,
                                selectedVenue!.venueId!,
                                "performerName",
                                sectionPrices);
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
