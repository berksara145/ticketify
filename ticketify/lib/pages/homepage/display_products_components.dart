import 'package:ticketify/constants/constant_variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticketify/objects/event_model.dart';
import 'package:ticketify/pages/Organizator/event/events.dart';

List<String> categoryOptions = [
  'concert',
  'festival',
  'opera',
  // Add more categories as needed
];

class FilterContainer extends StatefulWidget {
  final String title;
  final Function({
    required String eventName,
    required String? selectedCategories,
    required DateTime? startDate,
    required DateTime? endDate,
    required double minPrice,
    required double maxPrice,
  }) updateFilters;

  const FilterContainer({
    Key? key,
    required this.title,
    required this.updateFilters,
  }) : super(key: key);

  @override
  _FilterContainerState createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  // Define variables to hold filter values
  String eventName = '';
  String? selectedCategories;
  DateTime? startDate;
  DateTime? endDate;
  double minPrice = 0;
  double maxPrice = 10000000;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size = screenSize.width > ScreenConstants.kMobileWidthThreshold
        ? 250
        : screenSize.width;

    return Padding(
      padding: const EdgeInsets.only(
          top: 100.0, bottom: 40.0, right: 20.0, left: 20.0),
      child: Container(
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: AppColors.greydark, width: 0.5),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                // Add your filter options here
                _buildFilterOption(
                  'Event Name:',
                  TextField(
                    onChanged: (value) => setState(() => eventName = value),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.white, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.white, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.white, width: 1.0),
                      ),
                    ),
                  ),
                ),
                _buildFilterOption(
                  'Choose Categories:',
                  DropdownButtonFormField<String>(
                    value: selectedCategories,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategories = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.white, width: 1.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.white, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.white, width: 1.0),
                      ),
                    ),
                    items: categoryOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
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
                // Add more filter options here as needed
                // Example: _buildFilterOption('Start Date', DatePickerWidget()),
                ElevatedButton(
                  onPressed: () {
                    // Call the updateFilters method with the current filter data
                    widget.updateFilters(
                      eventName: eventName,
                      selectedCategories: selectedCategories,
                      startDate: startDate,
                      endDate: endDate,
                      minPrice: minPrice,
                      maxPrice: maxPrice,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    textStyle:
                        const TextStyle(fontSize: 16, color: AppColors.blue),
                  ),
                  child: const Text(
                      'Apply Filters'), // Change button text if needed
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
