import 'package:ticketify/constants/constant_variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticketify/objects/event_model.dart';
import 'package:ticketify/pages/Organizator/event/events.dart';


class FilterContainer extends StatefulWidget {
  const FilterContainer({
    super.key,
    required this.title,
  });

  final String title;

  @override
  _FilterContainerState createState() => _FilterContainerState();
}

List<String> categoryOptions = [
  'Concert',
  'Festival',
  'Opera',
  // Add more categories as needed
];

class _FilterContainerState extends State<FilterContainer> {
  // Define variables to hold filter values
  String eventName = '';
  List<String> selectedCategories = [];
  DateTime? startDate;
  DateTime? endDate;
  double minPrice = 0;
  double maxPrice = 10000000;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  void _filterEvents() async {

    final String? token = await _getToken();

    // Construct the query parameters
    final Map<String, dynamic> data = {
      'category_name': selectedCategories.isNotEmpty ? selectedCategories[0] : '',
      'start_date': startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : '',
      'end_date': endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : '',
      'ticket_price_min': minPrice.toString(),
      'ticket_price_max': maxPrice.toString(),
      'event_name': eventName,
    };

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/event/getFilteredEvents'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      final List<dynamic> eventsData = jsonDecode(response.body);
      List<EventModel> filteredEvents = eventsData.map((event) {
        // Convert dynamic data to EventModel objects
        return EventModel.fromJson(event);
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventsPage(
            filteredEvents: filteredEvents,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size;
    if (screenSize.width > ScreenConstants.kMobileWidthThreshold) {
      size = 250;
    } else {
      size = screenSize.width;
    }
    return Padding(
      padding: const EdgeInsets.only(
          top: 100.0, bottom: 40.0, right: 20.0, left: 20.0),
      child: Container(
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: AppColors.greydark, // Siyah renkli border
            width: 0.5, // Border kalınlığı
          ),
          color: AppColors.filterColor,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 9),
            ),
          ],
        ),
        child: SingleChildScrollView(
          // Add a SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(
                20.0), // Add padding to the content inside the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildFilterOption(
                  'Event Name:',
                  TextField(
                    onChanged: (value) => setState(() => eventName = value),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.white, // Set the color of the border
                          width: 1.0, // Set the width of the border
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors
                              .white, // Set the color of the border when TextField is enabled
                          width: 1.0, // Set the width of the border
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors
                              .white, // Set the color of the border when TextField is focused
                          width: 1.0, // Set the width of the border
                        ),
                      ),
                    ),
                  ),
                ),
                _buildFilterOption(
                    'Choose Categories:',
                    DropdownButtonFormField<String>(
                      value: selectedCategories.isNotEmpty
                          ? selectedCategories[0]
                          : null,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategories.clear();
                          selectedCategories.add(newValue!);
                        });
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                AppColors.white, // Set the color of the border
                            width: 1.0, // Set the width of the border
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors
                                .white, // Set the color of the border when TextField is enabled
                            width: 1.0, // Set the width of the border
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors
                                .white, // Set the color of the border when TextField is focused
                            width: 1.0, // Set the width of the border
                          ),
                        ),
                      ),
                      items: categoryOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                _buildFilterOption(
                    'Time Interval:',
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: startDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: endDate ?? DateTime(2050),
                              ).then((pickedDate) {
                                if (pickedDate != null) {
                                  setState(() {
                                    startDate = pickedDate;
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                startDate != null
                                    ? 'Start: ${DateFormat('yyyy-MM-dd').format(startDate!)}'
                                    : 'Select start date',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: endDate ?? DateTime.now(),
                                firstDate: startDate ?? DateTime(2000),
                                lastDate: DateTime(2050),
                              ).then((pickedDate) {
                                if (pickedDate != null) {
                                  setState(() {
                                    endDate = pickedDate;
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                endDate != null
                                    ? 'End: ${DateFormat('yyyy-MM-dd').format(endDate!)}'
                                    : 'Select end date',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                _buildFilterOption(
                    'Ticket Price:',
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                minPrice = double.tryParse(value) ?? 0;
                              });
                            },
                            style: TextStyle(color: AppColors.greydark),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Min Price',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors
                                      .white, // Set the color of the border
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors
                                      .white, // Set the color of the border when TextField is enabled
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors
                                      .white, // Set the color of the border when TextField is focused
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                maxPrice = double.tryParse(value) ?? 0;
                              });
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Max Price',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors
                                      .white, // Set the color of the border
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors
                                      .white, // Set the color of the border when TextField is enabled
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors
                                      .white, // Set the color of the border when TextField is focused
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                ElevatedButton(
                  onPressed: _filterEvents,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    textStyle: const TextStyle(
                        fontSize: 16,
                        color: AppColors.blue), // Set text color here
                  ),
                  child: const Text('Reset Filters'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, Widget inputWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        inputWidget,
        const SizedBox(height: 16),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      eventName = '';
      selectedCategories.clear();
      startDate = null;
      endDate = null;
      minPrice = 0;
      maxPrice = 10000000;
    });
  }
}

class ClickableText extends StatefulWidget {
  const ClickableText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  State<ClickableText> createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
          onEnter: (event) {
            setState(() {
              color = Colors.black;
            });
          },
          onExit: (event) {
            setState(() {
              color = Colors.black;
            });
          },
          child:
              Center(child: Text(widget.text, style: TextStyle(color: color)))),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final String hint_text;
  const CustomSearchBar(this.hint_text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hint_text,
      hintStyle: MaterialStateProperty.all<TextStyle?>(AppFonts.allertaStencil),
      leading: const Icon(Icons.search),
      backgroundColor: MaterialStateProperty.all<Color?>(AppColors.searchBar),
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
    );
  }
}
