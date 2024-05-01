import 'dart:html';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'package:ticketify/pages/homepage/one_item_view.dart';
import 'package:ticketify/pages/homepage/purchase_ticket.dart';

class PurchaseTicket extends StatefulWidget {
  const PurchaseTicket({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostDTO post;

  @override
  State<PurchaseTicket> createState() => _OneItemViewState();
}

class _OneItemViewState extends State<PurchaseTicket> {
  late PostDTO post;
  String? chosen;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 40),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OneItemView(
                            post: post,
                          ),
                        ),
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
                      Text(
                        post.title,
                        style: TextStyle(fontSize: 52),
                      ),
                      Text(
                        "Date: ${widget.post.sdate}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Type:  ${widget.post.tags}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Placeholder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Tickets:",
                                  style: TextStyle(fontSize: 36),
                                ),
                                Container(
                                  height: 50,
                                  width: 500,
                                  child: DropdownButtonHideUnderline(
                                    child: GFDropdown(
                                      hint: Text(
                                        "Enter Section",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      dropdownButtonColor: AppColors.filterColor
                                          .withOpacity(0.4),
                                      value: chosen,
                                      onChanged: (dynamic newValue) {
                                        // Specify the type explicitly
                                        setState(() {
                                          chosen = newValue;
                                        });
                                      },
                                      items: [
                                        'Section1 - 1000 tl',
                                        'Section2 - 750 tl',
                                        'Section3 - 500 tl',
                                        'Section4 - 250 tl'
                                      ].map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            value,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
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

class PhonePurchaseTicketView {}
