import 'package:flutter/material.dart';
import 'package:ticketify/constants/constant_variables.dart';
import 'package:ticketify/general_widgets/page_title.dart';
import 'package:ticketify/objects/user_model.dart';
import 'package:ticketify/pages/admin/users/one_item_user.dart';

class UsersPage extends StatefulWidget {
  UsersPage({super.key, this.isDeleteEnabled = false});
  final bool isDeleteEnabled;

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<UserModel>> _usersFuture;
  bool _isDeleting =
      false; // New state to manage loading indicator during deletion

  @override
  void initState() {
    super.initState();
    _usersFuture = UtilConstants().getAllUsers(context);
  }

  Future<void> deleteUser(UserModel user) async {
    setState(() {
      _isDeleting = true;
    });
    await UtilConstants()
        .deleteUser(context, user.userId.toString(), user.userType!);
    setState(() {
      _usersFuture = UtilConstants().getAllUsers(context);
      _isDeleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(37),
          color: AppColors.greylight.withAlpha(255),
        ),
        margin:
            const EdgeInsets.only(top: 50.0, bottom: 50, left: 20, right: 20),
        padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageTitle(title: "Users"),
            SizedBox(height: 20),
            Expanded(
              child: _isDeleting
                  ? Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<UserModel>>(
                      future: _usersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        } else if (snapshot.hasData) {
                          final users = snapshot.data!;
                          return GridView.builder(
                            itemCount: users.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return InkWell(
                                onTap: widget.isDeleteEnabled
                                    ? () {}
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserOneItemView(User: user),
                                          ),
                                        );
                                      },
                                child: Card(
                                  color: AppColors.greylight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            "${user.firstName} ${user.lastName}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            user.email ?? "No email provided",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          if (user.money != null)
                                            Text("Balance: ${user.money}",
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                          Text("Type: ${user.userType}",
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                          SizedBox(height: 90),
                                          if (widget.isDeleteEnabled)
                                            ElevatedButton(
                                              onPressed: () => deleteUser(user),
                                              child: Text("Delete User",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        AppColors.buttonBlue),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(child: Text("No data available"));
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
