import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector_page_list.dart';
import 'package:ticketify/general_widgets/page_selector/page_selector_title.dart';
import 'package:ticketify/pages/issue/create_issue.dart';

class PageSelector extends StatefulWidget {
  final List<PageListConfig> pageListConfigs;
  final String title;
  final Function(String) returnActivePageName;
  final bool isCreateIssueEnabled;

  const PageSelector({
    super.key,
    required this.pageListConfigs,
    required this.title,
    required this.returnActivePageName,
    this.isCreateIssueEnabled = false,
  });

  @override
  State<PageSelector> createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  int activeIndex = 0;
  int innerIndex = 0;

  @override
  Widget build(BuildContext context) {
    double containerWidth = 400;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.5),
              blurRadius: 4,
              offset: Offset(0, 4), // Shadow position
            ),
          ],
          color: AppColors.greylight.withAlpha(255),
          borderRadius: BorderRadius.circular(37)),
      width: containerWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              PageSelectorTitle(title: widget.title),
              const SizedBox(
                height: 12,
              ),
              ...widget.pageListConfigs.asMap().entries.map((entry) {
                int currentIndex = entry.key;
                PageListConfig config = entry.value;
                return PageSelectorPageList(
                  title: config.title,
                  menuItems: config.menuItems,
                  iconData: config.iconData,
                  isActive: activeIndex == currentIndex,
                  setParentState: (newIndex) {
                    if (activeIndex != currentIndex) {
                      setState(() {
                        activeIndex = currentIndex;
                        innerIndex = newIndex;
                      });
                    }
                    setState(() {
                      innerIndex = newIndex;
                    });
                    widget.returnActivePageName(config.menuItems[
                        innerIndex]); // Pass the actual title of the active page list
                  },
                );
              }),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isCreateIssueEnabled)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateIssue(),
                      ),
                    );
                  },
                  child: Text(
                    "Create Issue",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                    ),
                  ),
                ),
              if (widget.isCreateIssueEnabled) SizedBox(height: 4),
              GestureDetector(
                onTap: () => print("Log Out Tapped"),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 28,
                      ),
                    ),
                    Icon(Icons.exit_to_app, color: Colors.red, size: 32),
                  ],
                ),
              ),
              SizedBox(height: 36),
            ],
          )
        ],
      ),
    );
  }

  int findOverallIndex(String itemName) {
    int overallIndex = 0; // This will keep track of the index across all lists

    for (PageListConfig config in widget.pageListConfigs) {
      for (String item in config.menuItems) {
        if (item == itemName) {
          return overallIndex; // Return the index if the item is found
        }
        overallIndex++; // Increment the index for each item encountered
      }
    }

    return -1; // Return -1 if the item is not found
  }
}

class PageListConfig {
  final String title;
  final List<String> menuItems;
  final IconData iconData;

  PageListConfig({
    required this.title,
    required this.menuItems,
    required this.iconData,
  });
}
