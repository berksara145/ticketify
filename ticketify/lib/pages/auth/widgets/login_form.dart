import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/auth_text_field.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Organizator/organizer_homepage.dart';
class LoginForm extends StatefulWidget {
  LoginForm({super.key, required this.setParentState});
  final VoidCallback setParentState;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String nameLabel = "Name";
  final String surnameLabel = "Surname";
  final String emailLabel = "Email";
  final String passwordLabel = "Password";

  String? userType;
   Future<void> _login() async {
    // Construct the login request payload
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
      'user_type': userType,
    };

    // Send the login request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/login'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      // Successful login, navigate to homepage or perform other actions
      if (userType == 'buyer'){
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      }
      if (userType == 'organizor'){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrganizerHomepage()),
      );
        
      }
    } else {
      // Login failed, display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
   }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image.asset(
              AssetLocations.design,
              width: 100,
              height: 100,
            ),
          ), // Replace with Image
          const SizedBox(height: 30),
          /** */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                // Set the background color
                color: AppColors
                    .blue, // Ensure AppColors.blue is defined in your application
                // Define the border
                border: Border.all(
                  color: Colors.black, // Color of the border
                  width: 1.0, // Width of the border
                ),
                // Set the border radius for rounded corners
                borderRadius: BorderRadius.all(
                  Radius.circular(10), // Radius of 10
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Select User Type',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: <String>['admin', 'buyer', 'organizer', 'worker_bee']
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: userType,
                  onChanged: (String? value) {
                    setState(() {
                      userType = value;
                    });
                  },
                  buttonStyleData: const ButtonStyleData(),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AuthTextField(controller: emailController, label: emailLabel),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                  controller: passwordController, label: passwordLabel),
              GestureDetector(
                onTap: () => {widget.setParentState()},
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {widget.setParentState()},
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            color: AppColors.buttonBlue,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Register.",
                        style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: _login,
            child: Container(
              width: 300,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.buttonBlue,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 25,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
