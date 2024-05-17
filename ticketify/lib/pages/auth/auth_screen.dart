import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/login_form.dart';
import 'package:ticketify/pages/auth/widgets/register_form.dart';
import 'package:ticketify/pages/auth/widgets/reset_passowrd_change_password.dart';
import 'package:ticketify/pages/auth/widgets/reset_password_enter_code.dart';
import 'package:ticketify/pages/auth/widgets/reset_password_get_mail.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

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
                  Text(
                    'TICKETIFY',
                    style: GoogleFonts.allertaStencil(
                      textStyle: const TextStyle(
                        color: AppColors.black,
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: isLogin
                   ? LoginForm(
                       setParentState: () => setState(() {
                             isLogin = false;
                           }))
                  : RegisterForm(
                      setParentState: () => setState(() {
                            isLogin = true;
                          })))
        ],
      ),
    );
  }
}

class ResetPassWordChangePassword {}
