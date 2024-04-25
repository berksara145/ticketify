import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class AppFonts {
  static TextStyle allertaStencil = GoogleFonts.allertaStencil();
}

class AppColors {
  static const Color grey = Colors.grey;
  static const Color white = Color(0xffffffff);
  static const Color secondBackground = Color(0xffd9d9d9);
  static const Color black = Color(0xff000000);
  static const Color green = Color(0xBF00ACB5);
  static const Color blue = Color.fromRGBO(127, 199, 217, 0.366);
  static const Color buttonBlue = Color.fromRGBO(54, 84, 134, 1);

  static const Color filterColor = Color(0xff393e46);
  static const Color searchBar = Color(0xffa1babd);

  static const Color purple1 = Color(0xff592356);
  static const Color purple2 = Color(0xff8C4688);
  static const Color purple3 = Color(0xffB488B3);

  static const Color primary = Color(0xff592356);
  static const Color secondary = Color(0xff073500);

  static const Color iconColor = Color(0xff442f29);

  static const Color passiveButtonColor = Color(0xffBCBCBC);
}

class AssetLocations {
  static const String compwoman = "lib/Assets/bilgisayarkadin.png";
  static const String design = "lib/Assets/ticketify_logo.png";
  //static const String userPhoto = "lib/Assets/user_photo.jpg";
}

class ScreenConstants {
  static const int kMobileWidthThreshold = 500;
}
