import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/objects/user_model.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'package:ticketify/pages/homepage/purchase_ticket.dart';

class UserOneItemView extends StatefulWidget {
  UserOneItemView({
    Key? key,
    this.User,
    this.event_id = "0",
  }) : super(key: key);

  final UserModel? User;
  final String event_id;
  @override
  State<UserOneItemView> createState() => _UserOneItemViewState();
}

class _UserOneItemViewState extends State<UserOneItemView> {
  late UserModel User;
  late String event_id;
  @override
  void initState() {
    super.initState();
    User = widget.User!;
    event_id = widget.event_id;
  }

  @override
  Widget build(BuildContext context) {
    return DesktopUserOneItemView(
      User: User,
      widget: widget,
      event_id: event_id,
    );
  }
}

class DesktopUserOneItemView extends StatelessWidget {
  DesktopUserOneItemView({
    super.key,
    this.User,
    required this.event_id,
    required this.widget,
  });

  UserModel? User;
  final UserOneItemView widget;
  final String event_id;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: UserAppBar(),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Container(
          height: height - 150,
          decoration: BoxDecoration(
            color: AppColors.secondBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 40),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios_sharp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${User!.firstName!} ${User!.lastName!}",
                            style: TextStyle(fontSize: 52),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "User Details",
                                      style: TextStyle(fontSize: 36),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                                "Contact Adress: ${User?.email}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                                "User Type: ${User?.userType}"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
