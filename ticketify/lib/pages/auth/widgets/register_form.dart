import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/auth_text_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key, required this.setParentState}) : super(key: key);
  final VoidCallback setParentState;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final String nameLabel = "Name";
  final String surnameLabel = "Surname";
  final String emailLabel = "Email";
  final String passwordLabel = "Password";
  final String phoneLabel = "Phone no.";

  String? userType;

  Future<void> _signup() async {
    // Construct the register request payload
    final Map<String, dynamic> data = {
      'first_name': nameController.text,
      'last_name': surnameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'user_type': userType,
      'phone': phoneController.text,
    };

    // Send the register request to your Flask backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/register'), // Update with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      // Registration successful, switch to login form
      widget.setParentState();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully!')),
      );
    } else {
      // Registration failed, display error message in a dialog
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody['message'] ?? 'Sign up failed');
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                color: AppColors.blue, // Ensure AppColors.blue is defined in your application
                // Define the border
                border: Border.all(
                  color: Colors.black, // Color of the border
                  width: 1.0, // Width of the border
                ),
                // Set the border radius for rounded corners
                borderRadius: const BorderRadius.all(
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
          AuthTextField(controller: nameController, label: nameLabel),
          const SizedBox(height: 20),
          AuthTextField(controller: surnameController, label: surnameLabel),
          const SizedBox(height: 20),
          AuthTextField(controller: emailController, label: emailLabel),
          const SizedBox(height: 20),
          AuthTextField(controller: passwordController, label: passwordLabel),
          if (userType == 'organizer') ...[
            const SizedBox(height: 20),
            AuthTextField(controller: phoneController, label: phoneLabel),
          ],
          GestureDetector(
            onTap: widget.setParentState,
            child: const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                        color: AppColors.buttonBlue,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Log in.",
                    style: TextStyle(
                        color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: _signup,
            child: Container(
              width: 300,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.buttonBlue,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Sign Up',
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
