import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/pages/auth/widgets/appbar/user_app_bar.dart';
import 'package:ticketify/pages/homepage/ItemGrid.dart';
import 'package:ticketify/pages/homepage/one_item_view.dart';

class PurchaseTicket extends StatefulWidget {
  PurchaseTicket({
    Key? key,
    this.post,
    required this.event_id,
  }) : super(key: key);

  final PostDTO? post;
  final String event_id;

  @override
  State<PurchaseTicket> createState() => _OneItemViewState();
}

class _OneItemViewState extends State<PurchaseTicket> {
  late PostDTO post;
  String? chosen;
  Map<String, int> selectedSections = {};
  Map<String, int> cartItems = {};

  // Section prices map
  Map<String, int> sectionPrices = {
    'Section1 - 1000 tl': 1000,
    'Section2 - 750 tl': 750,
    'Section3 - 500 tl': 500,
    'Section4 - 250 tl': 250,
  };

  @override
  void initState() {
    super.initState();
    post = widget.post!;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
                                      onTap: () {},
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
                                    selectedSections[chosen!] = 1;
                                  }
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
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        ...selectedSections.entries.map((entry) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(fontSize: 20),
                              ),
                              DropdownButton<int>(
                                value: entry.value,
                                items: List.generate(10, (index) => index + 1)
                                    .map((number) {
                                  return DropdownMenuItem<int>(
                                    value: number,
                                    child: Text(number.toString()),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedSections[entry.key] = newValue!;
                                    // Update cart items when ticket count changes
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
    cartItems.forEach((key, value) {
      totalPrice += sectionPrices[key]! * value;
    });
    return totalPrice;
  }
}
