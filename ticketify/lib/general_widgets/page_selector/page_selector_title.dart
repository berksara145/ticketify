import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';

class PageSelectorTitle extends StatelessWidget {
  const PageSelectorTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    // Calculate the width as 1/5th of the screen width

    return Container(
      alignment: Alignment.center,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: AppColors.greydark,
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 28, color: Colors.black),
        softWrap: true,
        textAlign: TextAlign.center,
        // Ensures the text does not exceed the container
      ),
    );
  }
}
