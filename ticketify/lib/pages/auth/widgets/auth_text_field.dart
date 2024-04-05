import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {super.key, required this.controller, required this.label});
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.blue,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black, width: 1.0)),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black, width: 1.5)),
      ),
    );
  }
}
