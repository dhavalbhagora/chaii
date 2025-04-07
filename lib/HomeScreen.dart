import 'package:chaii/Colors/Color.dart';
import 'package:chaii/Model/totalmodal.dart';
import 'package:chaii/Screen/Add_Customer.dart';
import 'package:chaii/Screen/Bill.dart';
import 'package:chaii/Screen/Bill_History.dart';
import 'package:chaii/Screen/MenuItems.dart';
import 'package:chaii/Screen/New_oder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API/Api_total.dart';
import 'Screen/LoginScreen.dart';
import 'Screen/customerlist.dart';
import 'custom_widget/MenuWidget.dart';
import 'main.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String shopName = 'Tea & Food Point';
  String shopId = '20';
  // late Future<List<total>> futuretotal;
  late Future<List<total>> futuretotal;
  double totalAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
    setState(() {
      futuretotal = ApiTotal().fetchtotal(shopId);
    });
  }

  void initialize() {
    //await fetchShopDetails(); // Ensure shop details are fetched first
    setState(() {
      futuretotal = ApiTotal()
          .fetchtotal(shopId); // Initialize futuretotal after shopId is set
    });
    getDailyQuantity(); // Call this separately if not dependent on shopId
  }

  Future<void> fetchShopDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      shopName = prefs.getString('shopName') ?? 'No Shop Name';
      shopId = prefs.getString('shopId') ?? 'No Shop ID';
    });
  }

  void showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: MyColors.primaryColor),
            SizedBox(width: 10),
            Text('Logout'),
          ],
        ),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              logout();
            },
            child: Text(
              'Confirm',
              style: TextStyle(color: MyColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.bg,
      appBar: AppBar(
        title: Text(
          '$shopName',
          style: TextStyle(
              color: MyColors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: MyColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
            ),
            style: IconButton.styleFrom(foregroundColor: Colors.white),
            onPressed: showLogoutConfirmationDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    color: MyColors.primaryColor,
                    child: Container(
                      height: screenWidth * 0.5,
                      width: screenHeight * 0.2,
                      child: FutureBuilder<List<total>>(
                        future: futuretotal,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: SizedBox(
                                width: 60.0, // Adjust the size
                                height: 60.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4.0, // Customize thickness
                                  color: MyColors
                                      .primaryColor, // Use your theme color
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final total1 = snapshot.data!;

                            return ListView.builder(
                              itemCount: total1.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: screenWidth * 0.4,
                                  height: screenHeight * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  futuretotal = ApiTotal()
                                                      .fetchtotal(shopId);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.refresh,
                                                color: Colors.white,
                                              ))
                                        ],
                                      ),
                                      Text(
                                        'This Month Total Sell:',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${total1[index].total_sum} ',
                                        style: TextStyle(
                                            color: MyColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Card(
                    color: MyColors.primaryColor,
                    child: Container(
                      height: screenWidth * 0.5,
                      width: screenHeight * 0.2,
                      child: FutureBuilder<int>(
                        future: getDailyQuantity(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            var count = snapshot.data;
                            return Container(
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              count = count;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      'Today Selling Items:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '$count',
                                    style: TextStyle(
                                        color: MyColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    // ),

                    // _buildTopCard('0', 'Tea/Coffee in August', Icons.coffee),
                    // _buildTopCard('₹ 0', 'Amount of August', Icons.attach_money),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomMenu(
                    value: 'Customer',
                    iconData: Icons.group_add,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.15,
                    onPress: AddCustomerPage,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CustomMenu(
                    value: 'Menu Item',
                    iconData: Icons.inventory,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.15,
                    onPress: Menuitempage,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CustomMenu(
                    value: 'Customer List',
                    iconData: Icons.person,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.15,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerList(
                                    shopId: '$shopId',
                                  )));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CustomMenu(
                    value: 'New Oder',
                    iconData: Icons.add,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.15,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewOrder(
                                    shopId: '$shopId',
                                  )));
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CustomMenu(
                    value: 'Generate Bill',
                    iconData: Icons.payment,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.15,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GenerateOder(
                                    shopId: '$shopId',
                                  )));
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CustomMenu(
                    value: 'Bill History',
                    iconData: Icons.history,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.15,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BillHistory(
                                    shopId: '$shopId',
                                  )));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewOrder(
                        shopId: '$shopId',
                      )));
        }, // Increment counter when FAB is pressed
        child: Icon(
          Icons.add_box,
          color: Colors.white,
        ),
        backgroundColor: MyColors.primaryColor,
        shape: CircleBorder(),
      ),
    );
  }

  void AddCustomerPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddCustomer(
                  shopId: '$shopId',
                )));
  }

  void Menuitempage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Menuitems(
                  shopId: '$shopId',
                )));
  }

  Future<void> logout() async {
    var sharedpref = await SharedPreferences.getInstance();
    sharedpref.setBool(mychaiscreenState.KEYLOGIN, true);
    resetDailyQuantity();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<int> getDailyQuantity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return prefs.getInt(todayKey) ?? 0; // Return 0 if not found
  }

  Future<void> resetDailyQuantity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Reset the quantity to zero
    await prefs.setInt(todayKey, 0);
  }
}
