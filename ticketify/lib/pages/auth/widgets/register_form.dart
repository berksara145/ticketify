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
  final TextEditingController controller = TextEditingController();

  final String label = "DENEME";

  String? userType;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            AssetLocations.design,
            width: 100,
            height: 100,
          ), // Replace with Image
          const SizedBox(height: 30),
          /** */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth / 2,
              decoration: BoxDecoration(color: AppColors.blue),
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
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AuthTextField(controller: controller, label: label),
          const SizedBox(height: 20),
          AuthTextField(controller: controller, label: label),
          const SizedBox(height: 20),
          AuthTextField(controller: controller, label: label),
          const SizedBox(height: 20),
          AuthTextField(controller: controller, label: label),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Homepage()));
            },
            child: Container(
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
