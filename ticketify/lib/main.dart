import 'package:flutter/material.dart';
import 'package:ticketify/general_widgets/selected_page.dart';
import 'package:ticketify/pages/auth/auth_screen.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'package:ticketify/pages/homepage/purchase_ticket.dart';
import 'package:ticketify/pages/profile/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProfilePage(),
    );
  }
}
