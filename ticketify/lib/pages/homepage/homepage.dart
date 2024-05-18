import 'package:flutter/material.dart';

import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/homepage/display_products.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: UserAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.0), // Adjust the horizontal padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DisplayProducts(),
            ),
          ],
        ),
      ),
    );
  }
}
