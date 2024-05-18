import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:ui';

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

class UtilConstants {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> getAllEvents() async {
    // Construct the login request payload
    final String? token = await getToken();
    // final Map<String, dynamic> data = {
    //   'issue_text': _titleController.text,
    //   'issue_name': _descriptionController.text,
    // };

    // Send the login request to your Flask backend
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:5000/event/getAllEvents'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      //body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      // Successful login, navigate to homepage or perform other actions
      print(response.body);
    } else {
      // Login failed, display error message in a dialog
      // final Map<String, dynamic> responseBody = jsonDecode(response.body);
      //_showErrorDialog(responseBody['message'] ?? 'Issue create failed');
    }
  }
}
