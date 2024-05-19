import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/objects/event_model.dart';
import 'package:ticketify/objects/venue_model.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/one_item_view.dart';

class PurchaseTicket extends StatefulWidget {
  PurchaseTicket(
      {Key? key,
      this.post,
      required this.event_id,
      this.event,
      required this.maxTicketsLeft})
      : super(key: key);

  final PostDTO? post;
  final List<int> maxTicketsLeft;
  final EventModel? event;
  final String event_id;

  @override
  State<PurchaseTicket> createState() => _OneItemViewState();
}

class _OneItemViewState extends State<PurchaseTicket> {
  late PostDTO post;
  String? chosen;
  //Map<String, int> selectedSections = {};
  Map<String, Map<String, int>> selectedSections = {};

  Map<String, int> cartItems = {};

  // Section prices map

  @override
  void initState() {
    super.initState();
    post = widget.post!;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> sectionPrices =
        mapSectionPrices(widget.event!.ticketPrices!);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    int idx = 0;

    return Scaffold(
      appBar: UserAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          height: height - 150, // Applying padding to the container
          decoration: BoxDecoration(
            color: AppColors.secondBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
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
                                    event_id: post.id,
                                    event: widget.event!),
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
                              style: TextStyle(fontSize: 32),
                            ),
                            Text(
                              "Date: ${widget.post?.sdate}",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "Type:  ${widget.post?.tags}",
                              style: TextStyle(fontSize: 20),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      width: 300,
                                      height: 300,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cart',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          ...cartItems.entries.map((entry) {
                                            // Calculate total price for each section
                                            int totalPrice =
                                                sectionPrices[entry.key]! *
                                                    entry.value;
                                            return Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      entry.key,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      'x ${entry.value}',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                          Spacer(),
                                          Divider(
                                            thickness: 0.5,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            'Total Price: ${_calculateTotalPrice()} tl',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Map<int, int> ticketsToBeBought =
                                            extractSectionDetails(cartItems);
                                        List<int> ticketResults =
                                            []; // This list will store the return values

                                        // Iterate through each entry in the ticketsToBeBought map
                                        for (var entry
                                            in ticketsToBeBought.entries) {
                                          int sectionIndex = entry.key;
                                          int ticketCount = entry.value;

                                          // Loop to handle multiple tickets per section
                                          for (int i = 0;
                                              i < ticketCount;
                                              i++) {
                                            // Await the asynchronous chooseTicket function and add the result to the list
                                            int result = await UtilConstants()
                                                .chooseTicket(
                                                    context,
                                                    widget.event!.eventId
                                                        .toString(),
                                                    sectionIndex);
                                            ticketResults.add(result);
                                          }
                                        }
                                        await UtilConstants().buyTickets(
                                            context,
                                            widget.event!.eventId.toString(),
                                            ticketResults);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1)),
                                          padding: const EdgeInsets.all(5),
                                          child: const Text('Purchase Ticket')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
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
                              isExpanded: true,
                              hint: Text(
                                "Enter Section",
                                style: TextStyle(color: Colors.black),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              dropdownButtonColor:
                                  AppColors.filterColor.withOpacity(0.4),
                              value: chosen,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  chosen = newValue;
                                  if (!selectedSections.containsKey(chosen)) {
                                    int index = sectionPrices.keys
                                        .toList()
                                        .indexOf(chosen!);
                                    selectedSections[chosen!] = {
                                      'count': 1,
                                      'index': index
                                    };
                                  }
                                });
                              },
                              items: sectionPrices.keys.map((String key) {
                                return DropdownMenuItem(
                                  value: key,
                                  child: Text(
                                    key,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        ...selectedSections.entries.map((entry) {
                          int? sectionIndex = entry.value['index'];
                          int? ticketCount = entry.value['count'];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(fontSize: 20),
                              ),
                              DropdownButton<int>(
                                value: ticketCount,
                                items: List.generate(
                                    widget.maxTicketsLeft[sectionIndex!],
                                    (index) => index + 1).map((number) {
                                  return DropdownMenuItem<int>(
                                    value: number,
                                    child: Text(number.toString()),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedSections[entry.key] = {
                                      'count': newValue!,
                                      'index': sectionIndex
                                    };
                                    _updateCart(entry.key, newValue);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    selectedSections.remove(entry.key);
                                    cartItems.remove(entry.key);
                                  });
                                },
                              )
                            ],
                          );
                        }).toList()
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Update cart items
  void _updateCart(String section, int ticketCount) {
    setState(() {
      cartItems[section] = ticketCount;
    });
  }

  int _calculateTotalPrice() {
    int totalPrice = 0;
    Map<String, int> sectionPrices =
        mapSectionPrices(widget.event!.ticketPrices!);
    cartItems.forEach((key, value) {
      totalPrice += sectionPrices[key]! * value;
    });
    return totalPrice;
  }
}

Map<int, int> extractSectionDetails(Map<String, int> cartItems) {
  Map<int, int> extractedDetails = {};

  cartItems.forEach((key, value) {
    // Assuming the format is always "Section X - YYY tl"
    // Extract the section number from the string
    final sectionNumberString =
        key.split(' ')[1]; // This gets the '2' from "Section 2 - 5555 tl"
    int sectionNumber = int.parse(sectionNumberString); // Convert to int

    // Now map this section number to its corresponding value in the new map
    extractedDetails[sectionNumber] = value;
  });

  return extractedDetails;
}

Map<String, int> mapSectionPrices(String prices) {
  // Split the prices string into a list of prices
  List<String> priceList = prices.split('-');

  // Create a map to hold the section names and their corresponding prices
  Map<String, int> sectionPrices = {};

  // Determine the number of sections based on the number of prices in the list
  int sectionCount = priceList.length;

  // Loop through the number of sections and create the map entries
  for (int i = 0; i < sectionCount; i++) {
    // Construct the section name
    String sectionName = 'Section ${i + 1} - ${priceList[i]} tl';

    // Parse the price and add it to the map
    int price = int.parse(priceList[i]);
    sectionPrices[sectionName] = price;
  }

  return sectionPrices;
}

Future<List<int>> fetchAllSectionMaxTickets(
    Map<String, int> sectionPrices, eventId, context) async {
  List<Future<int>> futures = [];

  // Create a list of futures for each section
  int index = 0;
  print("maxTicketsLeft");
  sectionPrices.forEach((section, price) {
    futures.add(UtilConstants().getMaxTicketsLeft(context, eventId, index));
    index++;
  });
  print("here");

  // Wait for all futures to complete
  List<int> maxTicketsList = await Future.wait(futures);
  return maxTicketsList;
}
