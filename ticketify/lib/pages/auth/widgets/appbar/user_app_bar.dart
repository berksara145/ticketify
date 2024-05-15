import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticketify/pages/Organizator/organizer_homepage.dart';
import 'package:ticketify/pages/auth/auth_screen.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/profile/profile_page.dart';

class UserAppBar extends StatefulWidget implements PreferredSizeWidget {
  const UserAppBar({super.key});

  @override
  State<UserAppBar> createState() => _UserAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _UserAppBarState extends State<UserAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.green.withOpacity(0.55),
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: Row(
              children: [
                Image.asset(
                  AssetLocations.design,
                  width: 35,
                  height: 35,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "TICKETIFY",
                  style: GoogleFonts.allertaStencil(
                      textStyle: const TextStyle(
                    color: AppColors.black,
                    fontSize: 25,
                  )),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Homepage()));
            },
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateEventPage()));
            },
            icon: Icon(Icons.event_available_outlined)),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            icon: Icon(Icons.account_circle)),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()));
            },
            child: const Text(
              "Log out",
              style: TextStyle(color: AppColors.black),
            )),
      ],
    );
  }
}
