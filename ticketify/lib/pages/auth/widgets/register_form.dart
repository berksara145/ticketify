import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/auth_text_field.dart';
import 'package:ticketify/pages/homepage/homepage.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String nameLabel = "Name";
  final String surnameLabel = "Surname";
  final String emailLabel = "Email";
  final String passwordLabel = "Password";

  String? userType;

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
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: <String>['Admin', 'User', 'Guest']
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
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Homepage()));
            },
            child: Container(
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.buttonBlue,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
