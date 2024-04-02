import 'package:flutter/material.dart';
import 'package:ticketify/constants/app_theme.dart';
import 'package:ticketify/pages/auth/widgets/register_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: AppColors.green,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Placeholder(
                      fallbackHeight: 100,
                      color: Colors.red), // Replace with Logo
                  SizedBox(height: 30),
                  Text(
                    'TICKETIFY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: RegisterForm())
        ],
      ),
    );
  }
}
