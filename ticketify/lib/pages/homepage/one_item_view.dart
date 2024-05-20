import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/objects/event_model.dart';
import 'package:ticketify/pages/Organizator/organizer_homepage.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'package:ticketify/pages/homepage/purchase_ticket.dart';

class OneItemView extends StatefulWidget {
  OneItemView({Key? key, this.post, required this.event_id, this.event})
      : super(key: key);
  final EventModel? event;
  final PostDTO? post;
  final String event_id;
  @override
  State<OneItemView> createState() => _OneItemViewState();
}

class _OneItemViewState extends State<OneItemView> {
  late PostDTO post;
  late String event_id;
  @override
  void initState() {
    super.initState();
    post = widget.post!;
    event_id = widget.event_id;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if (width <= 1000) {
      return PhoneOneItemView(
        post: post,
        widget: widget,
        event_id: event_id,
      );
    }
    return DesktopOneItemView(
      post: post,
      widget: widget,
      event_id: event_id,
    );
  }
}

class PhoneOneItemView extends StatelessWidget {
  PhoneOneItemView({
    super.key,
    this.post,
    required this.event_id,
    required this.widget,
  });
  final PostDTO? post;
  final OneItemView widget;
  final String event_id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrganizerHomepage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios_sharp),
                ),
                SingleChildScrollView(
                  child: Container(
                    width: 1000,
                    height: 1000,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            post!.title,
                            style: TextStyle(fontSize: 52),
                          ),
                        ),
                        Text(
                          "Date: ${widget.post?.sdate}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Type:  ${widget.post?.tags}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Ticket Price:  250-8000 TL",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PurchaseTicket(
                                  maxTicketsLeft: [],
                                  post: post,
                                  event_id: event_id,
                                  event: widget.event,
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.filterColor,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                        SizedBox(
                          height: 20,
                        ),
                        Image.network(
                          widget.post?.imageUrl ??
                              "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg",
                          fit: BoxFit.cover,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Event Details",
                                  style: TextStyle(fontSize: 36),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text("Starts at: ${post?.sdate}"),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child:
                                          Text("Location: ${post?.location}"),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        post!.desc,
                                        softWrap:
                                            true, // Allow text to wrap to multiple lines
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text("Event Rules:"),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(post!.desc,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DesktopOneItemView extends StatelessWidget {
  DesktopOneItemView({
    super.key,
    this.post,
    required this.event_id,
    required this.widget,
  });

  PostDTO? post;
  final OneItemView widget;
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
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post!.title,
                            style: TextStyle(fontSize: 52),
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.only(right: 75.0),
                            child: TextButton(
                              onPressed: () async {
                                //GoRouter.of(context).go('/purchase/:eventID');
                                List<int> maxTicketsLeft =
                                    await fetchAllSectionMaxTickets(
                                        mapSectionPrices(
                                            widget.event!.ticketPrices!),
                                        event_id,
                                        context);
                                print(maxTicketsLeft);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PurchaseTicket(
                                        maxTicketsLeft: maxTicketsLeft,
                                        post: post,
                                        event_id: event_id,
                                        event: widget.event), // TODO
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  AppColors.filterColor,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
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
                      Text(
                        "Date: ${widget.post?.sdate}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Type:  ${widget.post?.tags}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Ticket Price:  ${widget.post?.ticket_prices}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            widget.post?.imageUrl ??
                                "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg",
                            fit: BoxFit.cover,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SingleChildScrollView(
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
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                                "Starts at: ${post?.sdate}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                                "Location: ${post?.location}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                              post!.desc,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              softWrap:
                                                  true, // Allow text to wrap to multiple lines
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Text("Event Rules:"),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 4.0),
                                                child: Text(
                                                  post!.rules,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  //post.
                                                  softWrap: true,
                                                ),
                                              )
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

Future<List<int>> fetchAllSectionMaxTickets(
    Map<String, int> sectionPrices, eventId, context) async {
  List<Future<int>> futures = [];

  // Create a list of futures for each section
  int index = 0;
  sectionPrices.forEach((section, price) {
    futures.add(UtilConstants().getMaxTicketsLeft(context, eventId, index));
    index++;
  });

  // Wait for all futures to complete
  List<int> maxTicketsList = await Future.wait(futures);
  return maxTicketsList;
}
