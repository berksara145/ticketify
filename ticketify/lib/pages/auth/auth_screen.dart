import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticketify/constants/constant_variables.dart';
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
          Expanded(
            child: Container(
              color: AppColors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    AssetLocations.compwoman,
                    width: screenWidth / 2,
                    height: screenHeight / 2,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'TICKETIFY',
                      style: GoogleFonts.allertaStencil(
                        textStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
