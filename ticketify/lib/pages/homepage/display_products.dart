import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'ItemGrid.dart';
import 'display_products_components.dart';

class DisplayProducts extends StatefulWidget {
  const DisplayProducts({super.key});

  @override
  State<DisplayProducts> createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout();
  }
}

class PageLayout extends StatefulWidget {
  PageLayout({
    super.key,
  });


  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (screenSize.width > ScreenConstants.kMobileWidthThreshold)
            const FilterContainer(
              title: 'Filters',
              //children: [],
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0), // Add padding bottom to create space
                  child: Container(
                    height: 45, // Adjust height as needed
                    padding: EdgeInsets.symmetric(horizontal: 40.0), // Adjust padding as needed
                    child: const CustomSearchBar(
                        "Search for an event"
                    ),
                  ),
                ),
                if (screenSize.width <= ScreenConstants.kMobileWidthThreshold)
                  IconButton(
                    tooltip: "Filters",
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            width: double.infinity,
                            child: const Center(
                              child: FilterContainer(
                                title: 'Filters',
                                //children: [],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.list_alt_sharp),
                  ),
                Expanded(
                  child: ItemGrid(
                    scrollController: scrollController,
                    fetchDataFunction: (int currentPage, int pageSize) async {
                      // Replace this function with your actual data fetching logic
                      return [];
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
