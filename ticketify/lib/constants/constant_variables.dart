import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ticketify/objects/event_model.dart';
import 'package:ticketify/objects/user_model.dart';

import 'dart:ui';

import 'package:ticketify/objects/venue_model.dart';

class AppFonts {
  static TextStyle allertaStencil = GoogleFonts.allertaStencil();
}

class AppColors {
  static const Color greydark = Color(0xD9D9D9D9);
  static const Color greylight = Color(0xFFEEEEEE);

  static const Color white = Color(0xffffffff);
  static const Color secondBackground = Color(0xffd9d9d9);
  static const Color black = Color(0xff000000);
  static const Color green = Color(0xBF00ACB5);
  static const Color blue = Color(0x5D7FC7D9);
  static const Color buttonBlue = Color(0xFF365486);

  //static const Color filterColor = Color(0xff393e46);
  static const Color filterColor = Color(0xff5d6169);
  static const Color searchBar = Color(0xffa1babd);

  static const Color purple1 = Color(0xff592356);
  static const Color purple2 = Color(0xff8C4688);
  static const Color purple3 = Color(0xffB488B3);

  static const Color primary = Color(0xff592356);
  static const Color secondary = Color(0xff073500);

  static const Color iconColor = Color(0xff442f29);

  static const Color passiveButtonColor = Color(0xffBCBCBC);
}

class AssetLocations {
  static const String compwoman = "lib/Assets/bilgisayarkadin.png";
  static const String design = "lib/Assets/ticketify_logo.png";
  //static const String userPhoto = "lib/Assets/user_photo.jpg";
}

class ScreenConstants {
  static const int kMobileWidthThreshold = 500;
}

void _showErrorDialog(String message, BuildContext context) {
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

class UtilConstants {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<List<EventModel>> getAllEvents(BuildContext context) async {
    // Construct the login request payload
    final String? token = await getToken();
    try {
      final uri = Uri.parse('http://127.0.0.1:5000/event/getAllEvents');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        // Convert each item in the list to an EventModel
        List<EventModel> events = jsonData
            .map<EventModel>((json) => EventModel.fromJson(json))
            .toList();

        return events;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Event Found!')),
        );
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(response.body); // Optional: For debugging purposes

        _showErrorDialog(
            responseBody['message'] ?? 'Event loading failed', context);
        throw Exception('Failed to load Events: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that might occur during the HTTP request
      throw Exception('Error fetching event data: $e');
    }
  }

  Future<void> createVenue(
      BuildContext context,
      String venueName,
      String address,
      String phoneNo,
      String venueImage,
      int venueRowLength,
      int venueColumnLength,
      int venueSectionCount) async {
    // Retrieve the token
    final String? token = await getToken();

    // Construct the data payload with provided arguments
    final Map<String, dynamic> data = {
      'venue_name': venueName,
      'address': address,
      'phone_no': phoneNo,
      'venue_image': venueImage,
      'venue_row_length': venueRowLength,
      'venue_column_length': venueColumnLength,
      'venue_section_count': venueSectionCount,
    };
    print(jsonEncode(data));

    // Send the request to your Flask backend
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:5000/venue/create'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venue is created!')),
      );
      // Operation successful, navigate to homepage or perform other actions
      // Example: Navigator.pushReplacementNamed(context, '/homepage');
    } else {
      // Operation failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(
          responseBody['error'] ?? 'Venue creation failed', context);
    }
  }

  Future<VenueModel> getAllVenues(
    BuildContext context,
  ) async {
    // Fetch the token; ensure you handle the potential null token appropriately
    final String? token = await getToken();

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    try {
      // Construct the URI for your Flask backend endpoint
      final uri = Uri.parse('http://127.0.0.1:5000/venue/getAllVenue');

      // Send the HTTP GET request
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonData = jsonDecode(response.body);

        // Parse the JSON into your VenueModel
        return VenueModel.fromJson(jsonData);
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(response.body); // Optional: For debugging purposes

        _showErrorDialog(
            responseBody['error'] ?? 'Event creation failed', context);
        throw Exception('Failed to load venues: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that might occur during the HTTP request
      throw Exception('Error fetching venue data: $e');
    }
  }

  Future<void> createEvent(
      BuildContext context,
      String eventName,
      String startDate,
      String endDate,
      String eventCategory,
      String eventImage,
      String descriptionText,
      String eventRules,
      int venueId,
      String performerName,
      List<int> ticketPrices) async {
    // Retrieve the token
    final String? token = await getToken();

    // Construct the data payload with provided arguments
    final Map<String, dynamic> data = {
      'event_name': eventName,
      'start_date': startDate,
      'end_date': endDate,
      'event_category': eventCategory,
      'event_image': eventImage,
      'description_text': descriptionText,
      'event_rules': eventRules,
      'venue_id': venueId,
      'performer_name': performerName,
      'ticket_prices': ticketPrices,
    };

    // Send the request to your Flask backend
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:5000/event/createEvent'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Event is created!')));
      // Operation successful, navigate to homepage or perform other actions
      // Example: Navigator.pushReplacementNamed(context, '/homepage');
    } else {
      // Operation failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(response.body); // Optional: For debugging purposes

      _showErrorDialog(
          responseBody['error'] ?? 'Event creation failed', context);
    }
  }

  Future<List<UserModel>> getAllUsers(BuildContext context) async {
    // Construct the login request payload
    final String? token = await getToken();
    try {
      final uri = Uri.parse('http://127.0.0.1:5000/user/getUsers');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Initialize an empty list to collect all users
        List<UserModel> allUsers = [];

        // Function to convert each user entry to UserModel and add to allUsers list
        void extractUsers(String key) {
          List<dynamic> users = jsonData[key];
          var userList =
              users.map<UserModel>((json) => UserModel.fromJson(json)).toList();
          allUsers.addAll(userList);
        }

        // Extract and convert users from each category
        extractUsers('buyer');
        extractUsers('organizer');
        extractUsers('worker_bee');

        // Log the JSON data for debugging
        print(response.body);

        // Return the unified list of users
        return allUsers;
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(token); // Optional: For debugging purposes

        _showErrorDialog(
            responseBody['error'] ?? 'User loading failed', context);
        throw Exception('Failed to load Users: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that might occur during the HTTP request
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<void> deleteUser(
    BuildContext context,
    String userId,
    String userType,
  ) async {
    // Retrieve the token
    final String? token = await getToken();

    // Construct the data payload with provided arguments
    final Map<String, dynamic> data = {
      'user_id': userId,
      'user_type': userType,
    };

    // Send the request to your Flask backend
    final response = await http.delete(
      Uri.parse(
          'http://127.0.0.1:5000/user/deleteUser'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('User is delete!')));
      // Operation successful, navigate to homepage or perform other actions
      // Example: Navigator.pushReplacementNamed(context, '/homepage');
    } else {
      // Operation failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(response.body); // Optional: For debugging purposes

      _showErrorDialog(
          responseBody['error'] ?? 'User deletion failed', context);
    }
  }

  Future<int> getMaxTicketsLeft(
      BuildContext context, String eventId, int sectionIndex) async {
    final Map<String, dynamic> data = {
      'event_id': eventId,
      'category_num': sectionIndex + 1,
    };

    final String? token = await getToken();

    try {
      final uri = Uri.parse('http://127.0.0.1:5000/ticket/getMaxTicket');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Log the JSON data for debugging
        print(response.body);
        // Extract max_ticket_count from JSON and return it
        int maxTicketCount = jsonData['max_ticket_count'] as int;
        return maxTicketCount;
      } else {
        print("error");

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        _showErrorDialog(
            responseBody['error'] ?? 'Ticket loading failed', context);
        throw Exception('Failed to load ticket prices: ${response.body}');
      }
    } catch (e) {
      print("exception");

      // Handle any errors that might occur during the HTTP request
      throw Exception('Error fetching ticket data: $e');
    }
  }

  Future<int> chooseTicket(
      BuildContext context, String eventId, int sectionIndex) async {
    final Map<String, dynamic> data = {
      'event_id': eventId,
      'category_num': sectionIndex,
    };

    final String? token = await getToken();

    try {
      final uri = Uri.parse('http://127.0.0.1:5000/ticket/chooseTicket');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Log the JSON data for debugging
        print(response.body);
        // Extract max_ticket_count from JSON and return it
        int ticketId = jsonData['ticket_id'] as int;
        return ticketId;
      } else {
        print("error");

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        _showErrorDialog(
            responseBody['error'] ?? 'Ticket loading failed', context);
        throw Exception('Failed to load ticket prices: ${response.body}');
      }
    } catch (e) {
      print("exception");

      // Handle any errors that might occur during the HTTP request
      throw Exception('Error fetching ticket data: $e');
    }
  }

  Future<void> buyTickets(
      BuildContext context, String eventId, List<int> ids) async {
    final Map<String, dynamic> data = {
      'event_id': eventId,
      'ticket_ids': ids,
    };

    final String? token = await getToken();

    try {
      final uri = Uri.parse('http://127.0.0.1:5000/ticket/buyTicket');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        _showErrorDialog(
            jsonData['message'] ?? 'Can not buy ticket(s): ', context);
        print(response.body);
      } else {
        print("error");

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        _showErrorDialog(
            responseBody['error'] ?? 'Can not buy ticket(s): ', context);
        throw Exception('Failed to load ticket prices: ${response.body}');
      }
    } catch (e) {
      print("exception");

      // Handle any errors that might occur during the HTTP request
      throw Exception('Error buying ticket(s): $e');
    }
  }
}
