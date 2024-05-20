import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/profile/widgets/event_details.dart';

class ProfileBrowseTickets extends StatelessWidget {
  final bool isPastTickets;
  final List<ProfileItemData> items; // Add this line
  const ProfileBrowseTickets({super.key, this.isPastTickets = true, required this.items});

  @override
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(37),
          color: AppColors.greylight.withAlpha(255),
        ),
        margin:
            const EdgeInsets.only(top: 50.0, bottom: 50, left: 20, right: 20),
        //padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageTitle(title: isPastTickets ? "Purchased Tickets" : "Upcoming Tickets"),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                child: ListView(children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final event = items[index];

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EventDetails(event: event),
                          ));
                        },
                        child: Card(
                          color: AppColors.greylight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SingleChildScrollView(
                            // Disable scrolling
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 100, // Adjust height as needed
                                    child: Image.network(
                                      event.imageUrl,
                                      fit: BoxFit
                                          .cover, // or BoxFit.contain based on your preference
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    event.title ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ItemText(text: event.acceptDate),
                                  ItemText(text: event.location),
                                  ItemText(text: event.organizer),
                                  ItemText(text: event.ticketPrice.toString()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemText extends StatelessWidget {
  const ItemText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        //fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ProfileItemData {
  final String title;
  final String imageUrl;
  final String acceptDate;
  final String location;
  final String organizer;
  final int ticketPrice;
  final String ticket_id;

  ProfileItemData({
    this.imageUrl = "https://picsum.photos/200/300",
    required this.title,
    required this.acceptDate,
    required this.location,
    required this.organizer,
    required this.ticketPrice,
    required this.ticket_id
  });

  get address => null;
}
