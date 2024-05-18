import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';

class PageSelectorPageList extends StatefulWidget {
  final String title;
  final List<String> menuItems;
  final bool isActive;
  final Function(int) setParentState;
  final IconData iconData; // Add IconData parameter

  const PageSelectorPageList({
    super.key,
    required this.title,
    required this.menuItems,
    required this.iconData,
    required this.isActive,
    required this.setParentState,
  });

  @override
  State<PageSelectorPageList> createState() => _PageSelectorPageListState();
}

class _PageSelectorPageListState extends State<PageSelectorPageList> {
  bool _isExpanded = false;
  int _selectedIdx = 0; // State to keep track of selected index

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 30, vertical: 8),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget
                        .iconData), // Place the icon to the left of the title
                    const SizedBox(width: 8), // Space between icon and title
                    Text(widget.title,
                        style: const TextStyle(
                            fontSize: 18, overflow: TextOverflow.fade)),
                  ],
                ),
                Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 40, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.menuItems
                    .asMap()
                    .map((index, item) => MapEntry(
                          index,
                          GestureDetector(
                            onTap: () {
                              widget.setParentState(index);
                              setState(() {
                                _selectedIdx =
                                    index; // Update the selected index on tap
                              });
                            },
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 18,
                                color: _selectedIdx == index && widget.isActive
                                    ? AppColors.buttonBlue
                                    : Colors
                                        .black, // Change color based on selection
                              ),
                            ),
                          ),
                        ))
                    .values
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
