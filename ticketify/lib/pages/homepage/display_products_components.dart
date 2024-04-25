import 'package:ticketify/constants/constant_variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterContainer extends StatefulWidget {
  const FilterContainer({
    Key? key,
    required this.title,
  }) : super(key: key);

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
  String venueLocation = '';
  String cityName = '';
  double minPrice = 0;
  double maxPrice = 10000000;

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
            color: AppColors.grey, // Siyah renkli border
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
                    )),
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
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(labelText: 'Min Price'),
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
                            decoration: InputDecoration(labelText: 'Max Price'),
                          ),
                        ),
                      ],
                    )),
                ElevatedButton(
                  onPressed: _resetFilters,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    textStyle: const TextStyle(fontSize: 16),
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
      venueLocation = '';
      cityName = '';
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
  const CustomSearchBar(this.hint_text, {Key? key}) : super(key: key);

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
