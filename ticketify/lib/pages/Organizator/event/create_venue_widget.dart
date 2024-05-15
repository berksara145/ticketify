import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/homepage/display_products_components.dart';

class CreateVenueWidget extends StatefulWidget {
  @override
  _CreateVenueWidgetState createState() => _CreateVenueWidgetState();
}

class _CreateVenueWidgetState extends State<CreateVenueWidget> {
  String selectedEventType = 'Concert';
  String venueName = '';
  String location = '';
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
  TextEditingController _rowController = TextEditingController();
  TextEditingController _columnController = TextEditingController();
  TextEditingController sectionCountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
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
        width: MediaQuery.of(context).size.width - 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageTitle(title: "Create Venue"),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        venueName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter Name of the venue',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Enter Row Number"),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        ),
                        child: TextField(
                          controller: _rowController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly // Restrict input to digits only
                          ],
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Enter Column Number"),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: TextField(
                          controller: _columnController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly // Restrict input to digits only
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        venueName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter Name of the venue',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        location = value;
                      });
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.location_on),
                      labelText: 'Enter Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                          ),
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly // Restrict input to digits only
                            ],
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.phone),
                              border: InputBorder.none,
                              hintText: 'Enter Phone Number',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Total Section"),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: sectionCountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly // Restrict input to digits only
                          ],
                          decoration: InputDecoration(
                            hintText: 'Total Section Count',
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
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
                            children: [Text('Upload Photo'), Icon(Icons.photo)],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Spacer(), // Add Spacer to push the TextField to the right
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Venue Capacity"),
                      ),
                      Container(
                        width: 100, // Set a fixed width for the TextField
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        ),
                        child: TextField(
                          controller: sectionCountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly // Restrict input to digits only
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // Create event logic here
                    },
                    child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        padding: const EdgeInsets.all(5),
                        child: const Text('Create')),
                  ),
                ],
              ),
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
