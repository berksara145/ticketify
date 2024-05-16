import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/pages/profile/widgets/profile_item.dart';

class ProfileBrowseTickets extends StatelessWidget {
  final bool isPastTickets;
  const ProfileBrowseTickets({super.key, this.isPastTickets = true});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final List<ProfileItemData> items = [
      ProfileItemData(
          title: "Event 1",
          acceptDate: "Date 1",
          location: "Location 1",
          organizer: "Organizer 1"),
      ProfileItemData(
          title: "Event 2",
          acceptDate: "Date 2",
          location: "Location 2",
          organizer: "Organizer 2"),
      ProfileItemData(
          title: "Event 2",
          acceptDate: "Date 2",
          location: "Location 2",
          organizer: "Organizer 2"),
      ProfileItemData(
          title: "Event 2",
          acceptDate: "Date 2",
          location: "Location 2",
          organizer: "Organizer 2"),
      ProfileItemData(
          title: "Event 2",
          acceptDate: "Date 2",
          location: "Location 2",
          organizer: "Organizer 2"),
      ProfileItemData(
          title: "Event 2",
          acceptDate: "Date 2",
          location: "Location 2",
          organizer: "Organizer 2"),
      ProfileItemData(
          title: "Event 2",
          acceptDate: "Date 2",
          location: "Location 2",
          organizer: "Organizer 2"),
      ProfileItemData(
          title: "Event 2",
          acceptDate: "Date 2",
          location: "Location 2",
          organizer: "Organizer 2"),
      // // Add more items as needed
    ];
    return Container(
      height: 800,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 4), // Shadow position
            ),
          ],
          color: AppColors.greylight.withAlpha(255),
          borderRadius: BorderRadius.circular(37)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const PageTitle(title: "Past Events"),
          Wrap(
            spacing: 8.0, // space between rows
            runSpacing: 4.0, // space between columns
            children: items
                .map((item) => ProfileItem(
                      title: item.title,
                      acceptDate: item.acceptDate,
                      location: item.location,
                      organizer: item.organizer,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ProfileItemData {
  final String title;
  final String acceptDate;
  final String location;
  final String organizer;

  ProfileItemData({
    required this.title,
    required this.acceptDate,
    required this.location,
    required this.organizer,
  });
}
