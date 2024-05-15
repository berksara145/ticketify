import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final bool filterEnabled;
  final Function? filterFunc;
  const PageTitle(
      {super.key,
      required this.title,
      this.filterEnabled = false,
      this.filterFunc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      decoration: BoxDecoration(
        color: AppColors.greydark,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(36), bottom: Radius.circular(36)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (filterEnabled)
            GestureDetector(
              onTap: () {
                filterFunc!();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Filter",
                  style: const TextStyle(
                    color: AppColors.buttonBlue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
