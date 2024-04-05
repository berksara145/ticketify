import 'package:flutter/material.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';

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
    );
  }
}
