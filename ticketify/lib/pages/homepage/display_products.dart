import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'ItemGrid.dart';
import 'display_products_components.dart';

class DisplayProducts extends StatefulWidget {
  const DisplayProducts({super.key});

  @override
  State<DisplayProducts> createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout();
  }
}

class PageLayout extends StatefulWidget {
  PageLayout({
    super.key,
  });

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  Future<void> _fetchData() async {
    // Send the login request to your Flask backend
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:5000/getAllEvents'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);

    // Handle the response from the backend
    if (response.statusCode == 200) {
      // Successful login, navigate to homepage or perform other actions
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      String token = responseBody['access_token'];

      // Save the token securely
      //   await storage.write(key: 'access_token', value: token);
      //   if (userType == 'buyer') {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const Homepage()),
      //     );
      //   }
      //   if (userType == 'organizer') {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const OrganizerHomepage()),
      //     );
      //   }
      // } else {
      //   // Login failed, display error message in a dialog
      //   final Map<String, dynamic> responseBody = jsonDecode(response.body);
      //   _showErrorDialog(responseBody['message'] ?? 'Login failed');
      // }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (screenSize.width > ScreenConstants.kMobileWidthThreshold)
            const FilterContainer(
              title: 'Filters',
              //children: [],
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0,
                      bottom: 20.0), // Add padding bottom to create space
                  child: Container(
                    height: 45, // Adjust height as needed
                    padding: EdgeInsets.symmetric(
                        horizontal: 40.0), // Adjust padding as needed
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
                            child: const Center(
                              child: FilterContainer(
                                title: 'Filters',
                                //children: [],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.list_alt_sharp),
                  ),
                Expanded(
                  child: ItemGrid(
                    scrollController: scrollController,
                    fetchDataFunction: (int currentPage, int pageSize) async {
                      // Replace this function with your actual data fetching logic
                      return [];
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
