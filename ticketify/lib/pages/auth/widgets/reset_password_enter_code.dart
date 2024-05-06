import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/auth_text_field.dart';
import 'package:ticketify/pages/homepage/homepage.dart';

class ResetPassWordEnterCode extends StatefulWidget {
  ResetPassWordEnterCode({super.key});

  @override
  State<ResetPassWordEnterCode> createState() => _ResetPassWordEnterCodeState();
}

class _ResetPassWordEnterCodeState extends State<ResetPassWordEnterCode> {
  final TextEditingController emailController = TextEditingController();

  final String codeLabel = "Code";

  String? userType;

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
            child: AuthTextField(controller: emailController, label: codeLabel),
          ),
          const SizedBox(height: 20),

          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Homepage()));
            },
            child: Container(
              width: 300,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.buttonBlue,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Enter Code',
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
