import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ticketify/pages/Organizator/event/events.dart';

import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'ItemGrid.dart';
import 'display_products_components.dart';

class DisplayProducts extends StatefulWidget {
  const DisplayProducts({Key? key}) : super(key: key);

  @override
  State<DisplayProducts> createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts> {
  // Define state variables
  String eventName = '';
  List<String> selectedCategories = [];
  DateTime? startDate;
  DateTime? endDate;
  double minPrice = 0;
  double maxPrice = 10000000;

  // Method to update state with filter data
  void updateFilters(
      {String eventName = '',
        List<String> selectedCategories = const [],
        DateTime? startDate,
        DateTime? endDate,
        double minPrice = 0,
        double maxPrice = 10000000}) {
    setState(() {
      this.eventName = eventName;
      this.selectedCategories = selectedCategories;
      this.startDate = startDate;
      this.endDate = endDate;
      this.minPrice = minPrice;
      this.maxPrice = maxPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      // Pass state data and update method to PageLayout
      eventName: eventName,
      selectedCategories: selectedCategories,
      startDate: startDate,
      endDate: endDate,
      minPrice: minPrice,
      maxPrice: maxPrice,
      updateFilters: updateFilters,
    );
  }
}

class PageLayout extends StatefulWidget {
  final String eventName;
  final List<String> selectedCategories;
  final DateTime? startDate;
  final DateTime? endDate;
  final double minPrice;
  final double maxPrice;
  final Function({
  String eventName,
  List<String> selectedCategories,
  DateTime? startDate,
  DateTime? endDate,
  double minPrice,
  double maxPrice,
  }) updateFilters;

  const PageLayout({
    Key? key,
    required this.eventName,
    required this.selectedCategories,
    required this.startDate,
    required this.endDate,
    required this.minPrice,
    required this.maxPrice,
    required this.updateFilters,
  }) : super(key: key);

  @override
  _PageLayoutState createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  // Method to pass filter data to EventsPage
  Map<String, dynamic> getFilterData() {
    return {
      'event_name': widget.eventName,
      'selected_categories': widget.selectedCategories,
      'start_date': widget.startDate,
      'end_date': widget.endDate,
      'min_price': widget.minPrice,
      'max_price': widget.maxPrice,
    };
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
              updateFilters: widget.updateFilters, // Pass update method
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
                                updateFilters: widget.updateFilters,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.list_alt_sharp),
                  ),
                EventsPage(
                  data: getFilterData(), // Pass filter data to EventsPage
                ),
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
