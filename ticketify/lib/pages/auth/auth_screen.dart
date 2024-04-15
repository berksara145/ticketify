import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/login_form.dart';
import 'package:ticketify/pages/auth/widgets/register_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            color: AppColors.green,
            width: screenWidth * 11 / 18,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 12,
                  ),
                  child: Image.asset(
                    AssetLocations.compwoman,
                    width: screenWidth / 2,
                    height: screenHeight / 2,
                  ),
                ),
                Text(
                  'TICKETIFY',
                  style: GoogleFonts.allertaStencil(
                    textStyle: TextStyle(
                      color: AppColors.black,
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: LoginForm())
        ],
      ),
    );
  }
}
