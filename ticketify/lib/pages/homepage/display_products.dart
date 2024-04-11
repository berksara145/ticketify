import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/constants/constant_variables.dart';

import 'display_products_components.dart';

class DisplayProducts extends StatefulWidget {
  const DisplayProducts({super.key});

  @override
  State<DisplayProducts> createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool onScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          PageLayout(onScreen: onScreen)
        ],
      ),
    );
  }
}

class PageLayout extends StatefulWidget {
  PageLayout({
    super.key,
    this.onScreen = false,
  });

  bool onScreen;

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
          if (screenSize.width > kMobileWidthThreshold)
            const FilterContainer(
              title: 'Filters',
              children: [],
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        height: 45, // Adjust height as needed
                        padding: EdgeInsets.symmetric(horizontal: 40.0), // Adjust padding as needed
                        child: const CustomSearchBar(
                          "Search for an event"
                        ),
                      ),
                      if (screenSize.width <= kMobileWidthThreshold)
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
                                      children: [],
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
          ),
        ],
      ),
    );
  }
}

typedef FetchDataFunction = Future<List<dynamic>> Function(
    int currentPage, int pageSize);

class ItemGrid extends StatefulWidget {
  final ScrollController scrollController;
  final FetchDataFunction fetchDataFunction;
  const ItemGrid(
      {Key? key,
        required this.scrollController,
        required this.fetchDataFunction})
      : super(key: key);

  @override
  State<ItemGrid> createState() => _ItemGridState();
}

class _ItemGridState extends State<ItemGrid> {
  final StreamController<List<dynamic>> _dataStreamController =
  StreamController<List<dynamic>>();
  Stream<List<dynamic>> get dataStream => _dataStreamController.stream;
  final List<dynamic> _currentItems = [];
  int _currentPage = 1;
  final int _pageSize = 20;
  late final ScrollController _scrollController;
  bool _isFetchingData = false;

  Future<void> _fetchPaginatedData() async {
    if (_isFetchingData) {
      // Avoid fetching new data while already fetching
      return;
    }
    try {
      _isFetchingData = true;
      setState(() {});

      final startTime = DateTime.now();

      /*final items = await widget.fetchDataFunction(
        _currentPage,
        _pageSize,
      );*/
      // Temporary replacement for fetching data
      final List<dynamic> items = List.generate(
        _pageSize,
            (index) => {
          'id': 'id_$index',
          'title': 'Title $index',
          'tags': 'Tags $index',
          'body': 'Body $index',
          'imageUrl': 'https://via.placeholder.com/150',
          'price': (index + 1) * 10.0,
          'user': 'User $index',
          'created': DateTime.now(),
        },
      );

      _currentItems.addAll(items);

      // Add the updated list to the stream without overwriting the previous data
      final endTime = DateTime.now();
      final timeDifference =
          endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;

      if (timeDifference < 2000) {
        // Delay for 2 seconds if the time taken by the API request is less then 2 seconds
        await Future.delayed(const Duration(milliseconds: 2000));
      }

      _dataStreamController.add(_currentItems);
      _currentPage++;
    } catch (e) {
      _dataStreamController.addError(e);
    } finally {
      // Set to false when data fetching is complete
      _isFetchingData = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = widget.scrollController;
    _fetchPaginatedData();
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        if (currentScroll == maxScroll) {
          // When the last item is fully visible, load the next page.
          _fetchPaginatedData();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator
          return const Center(child: CircularProgressIndicator());
        } //else if (snapshot.hasError) {
          //return ErrorDisplayComponents();}
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Display a message when there is no data
          return const Center(child: Text('No data available.'));
        } else {
          // Display the paginated data
          final items = snapshot.data;
          return Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0), // Adjust padding as needed
              color: AppColors.passiveButtonColor, // Example color, adjust as needed
              child: ListView(
                controller: _scrollController,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items!.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300, // Adjust max width as needed
                      mainAxisSpacing: 10, // Adjust spacing between rows as needed
                      crossAxisSpacing: 10, // Adjust spacing between items as needed
                      childAspectRatio: 1, // Maintain aspect ratio of 1:1 for items
                    ),
                    itemBuilder: (context, index) {
                      PostDTO post = PostDTO(
                        id: '1', // Example: Replace '1' with the actual ID
                        tags: 'Concert', // Example: Replace 'Sample Tags' with the actual tags
                        title: 'Mayfest & Mogollar', // Example: Replace 'Sample Title' with the actual title
                        imageUrl: 'https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg', // Example: Replace with actual image URL
                        sdate: DateTime.now(), // Example: Replace 'DateTime.now()' with the actual creation date
                        location: "Bilkent", // Example: Replace '10.0' with the actual price
                        organizer: 'Bilkent', // Example: Replace 'Sample User' with the actual user
                      );

                      return ProductCard(
                        post: post,
                      );
                    },
                  ),
                  if (_isFetchingData)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          );

        }
      },
    );
  }

  @override
  void dispose() {
    _dataStreamController.close();
    //we do not have control cover the _scrollController so it should not be disposed here
    // _scrollController.dispose();
    super.dispose();
  }
}

class PostDTO {
  final String id;
  final String tags;
  final String title;
  final String imageUrl;
  final DateTime sdate;
  final String location;
  final String organizer;

  PostDTO({
    required this.id,
    required this.tags,
    required this.title,
    required this.imageUrl,
    required this.sdate,
    required this.location,
    required this.organizer,
  });
}
class ProductCard extends StatefulWidget {
  final PostDTO post;
  final Color backgroundColor;

  ProductCard({
    this.backgroundColor = Colors.white,
    required this.post,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}


class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OneItemView(productId: widget.post.id ?? ""),
        //   ),
        // );
      },
      child: Card(
          color: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        child: SingleChildScrollView(// Disable scrolling
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100, // Adjust height as needed
                  child: Image.network(
                    widget.post.imageUrl ??
                        "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg",
                    fit: BoxFit.cover, // or BoxFit.contain based on your preference
                  ),
                ),
                Divider(), // Add a Divider below the Card
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // Wrap the title with Expanded
                      child: Text(
                        widget.post.title ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        widget.post.tags ?? "",
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Date: ${widget.post.sdate}",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "Location: ${widget.post.location}",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "Organizer: ${widget.post.organizer}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
