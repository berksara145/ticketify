import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ticketify/pages/Organizator/event/events.dart';

import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/constants/constant_variables.dart';
import '../../objects/event_model.dart';
import 'ItemGrid.dart';
import 'display_products_components.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({Key? key}) : super(key: key);

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  // Define state variables
  late Future<List<EventModel>> _eventsFuture;
  String eventName = '';
  String? selectedCategories;
  DateTime? startDate;
  DateTime? endDate;
  double minPrice = 0;
  double maxPrice = 10000000;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<List<EventModel>> _filterEvents() async {
    final String? token = await _getToken();

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/event/getFilteredEvents'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'event_name': eventName,
        'selected_categories': selectedCategories,
        'start_date': startDate?.toIso8601String(), // Convert DateTime to String
        'end_date': endDate?.toIso8601String(), // Convert DateTime to String
        'min_price': minPrice,
        'max_price': maxPrice,
      }),
    );

    if (response.statusCode == 200) {
      final dynamic responseData = jsonDecode(response.body);

      // Check if responseData is null or empty
      if (responseData == null || responseData.isEmpty) {
        return []; // Return an empty list
      }

      // Check if responseData is a list
      if (responseData is List) {
        List<EventModel> filteredEvents = responseData.map((eventJson) {
          return EventModel.fromJson(eventJson);
        }).toList();
        return filteredEvents;
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }




  // Method to update state with filter data
  void updateFilters({
    String eventName = '',
    String? selectedCategories,
    DateTime? startDate,
    DateTime? endDate,
    double minPrice = 0,
    double maxPrice = 10000000,
  }) {
    setState(() {
      this.eventName = eventName;
      this.selectedCategories = selectedCategories;
      this.startDate = startDate;
      this.endDate = endDate;
      this.minPrice = minPrice;
      this.maxPrice = maxPrice;
    });
    _updateEvents();
  }

  @override
  void initState() {
    super.initState();
    _updateEvents();
  }

  void _updateEvents() {
    if (eventName.isEmpty &&
        selectedCategories == null &&
        startDate == null &&
        endDate == null &&
        minPrice == 0 &&
        maxPrice == 10000000) {
      _eventsFuture = UtilConstants().getAllEvents(context);
    } else {
      _eventsFuture = _filterEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    // UtilConstants().getAllEvents(context); // Remove this line
    final ScrollController scrollController = ScrollController();
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (screenSize.width > ScreenConstants.kMobileWidthThreshold)
            FilterContainer(
              title: 'Filters',
              updateFilters:updateFilters, // Pass update method
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0), // Add padding bottom to create space
                  child: Container(
                    height: 45, // Adjust height as needed
                    padding:
                    EdgeInsets.symmetric(horizontal: 40.0), // Adjust padding as needed
                    child: const CustomSearchBar("Search for an event"),
                  ),
                ),
                if (screenSize.width <= ScreenConstants.kMobileWidthThreshold)
                  IconButton(
                    tooltip: "Filters",
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            width: double.infinity,
                            child: Center(
                              child: FilterContainer(
                                title: 'Filters',
                                // Pass update method
                                updateFilters: updateFilters,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.list_alt_sharp),
                  ),
                EventsPage(eventsFuture: _eventsFuture,),
                // Expanded(
                //   child: ItemGrid(
                //     scrollController: scrollController,
                //     fetchDataFunction: (int currentPage, int pageSize) async {
                //       // Replace this function with your actual data fetching logic
                //       return [];
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}