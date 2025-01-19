import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticketify/pages/Organizator/organizer_homepage.dart';
import 'package:ticketify/pages/admin/admin_page.dart';
import 'package:ticketify/pages/auth/auth_screen.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/profile/profile_page.dart';
import 'package:http/http.dart' as http;

import '../../../workerbee/worker_homepage.dart';

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
            onPressed: () {},
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Homepage()));
            },
            icon: Icon(Icons.shopping_bag_outlined)),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilePageBuyer()));
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

class OrganizerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const OrganizerAppBar({super.key});

  @override
  State<OrganizerAppBar> createState() => _OrganizerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _OrganizerAppBarState extends State<OrganizerAppBar> {
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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrganizerHomepage()));
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
                      builder: (context) => const OrganizerHomepage()));
            },
            icon: Icon(Icons.event_available_outlined)),
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

class AdminAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  @override
  State<AdminAppBar> createState() => _AdminAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AdminAppBarState extends State<AdminAppBar> {
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
                  MaterialPageRoute(builder: (context) => const AdminPage()));
            },
          ),
        ],
      ),
      actions: [
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

class WBAppBar extends StatefulWidget implements PreferredSizeWidget {
  const WBAppBar({super.key});

  @override
  State<WBAppBar> createState() => _WBAppBarBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WBAppBarBarState extends State<WBAppBar> {
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
                  MaterialPageRoute(builder: (context) => IssueListPage()));
            },
          ),
        ],
      ),
      actions: [
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
