import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/homepage.dart';

class OneItemView extends StatefulWidget {
  const OneItemView({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostDTO post;

  @override
  State<OneItemView> createState() => _OneItemViewState();
}

class _OneItemViewState extends State<OneItemView> {
  late PostDTO post;

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
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Homepage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios_sharp),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 75.0),
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.filterColor,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: Text(
                        "Check Tickets",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.title,
                            style: TextStyle(fontSize: 64),
                          ),
                        ],
                      ),
                      Text(
                        "Date: ${widget.post.sdate}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Type:  ${widget.post.tags}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Ticket Price:  250-8000 TL",
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 90.0),
                            child: Image.network(
                              widget.post.imageUrl ??
                                  "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Event Details",
                                  style: TextStyle(fontSize: 36),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: FittedBox(
                                            child:
                                                Text("Artist(s): ${post.id}")),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text("Starts at: ${post.sdate}"),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child:
                                            Text("Location: ${post.location}"),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Flexible(
                                          child: Text(
                                            "Event Info: ${post.id} is getting ready to bring you its popular songs with the ${post.organizer} organization.",
                                            softWrap:
                                                true, // Allow text to wrap to multiple lines
                                          ),
                                        ),
                                      ),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text("Event Rules:"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              "- All participants are required to have their valid ID with them.",
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              "- It is forbidden to bring outside food and drinks into the area.",
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                                "- For security reasons, piercing, cutting tools, flammable materials, drugs and illegal substances will not be taken into the area.",
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Text(
                                            "- It is forbidden to enter the area with pets.",
                                          ),
                                        ],
                                      ),
                                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
