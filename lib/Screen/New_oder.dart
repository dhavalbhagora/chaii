import 'package:chaii/API/Api_getmenuitem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/Api_getuser.dart';
import '../Colors/Color.dart';
import '../Model/menuitem_model.dart';
import '../Model/usermodel.dart';

class NewOrder extends StatefulWidget {
  final String shopId;
  const NewOrder({super.key, required this.shopId});
  @override
  _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  final formGlobalKey = GlobalKey<FormState>();
  List<String> sellers = [];
  List menuItems = [];
  String? selectedSeller;
  DateTime selectedDate = DateTime.now();
  String selectedFilter = "All";
  Map<String, int> quantities = {};
  Map<String, int> total = {};
  late Future<List<Menuitem>> futurermenu;
  late Future<List<UserModel>> futureCustomer;
  String? selectedItem;
  bool isBillSelected = true;
  int grandTotal = 0;
  DateTime now = DateTime.now();
  late String amount, name, date, time, status, shopid;
  String shopName = 'Tea & Food Point';
  String shopId = '20';

  // Future<void> fetchShopDetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     shopName = prefs.getString('shopName') ?? 'No Shop Name';
  //     shopId = prefs.getString('shopId') ?? 'No Shop ID';
  //   });
  // }

  @override
  void initState() {
    super.initState();
    initializeDailyQuantity();
    futurermenu = ApiServiceMenu().fetchMenuItems(widget.shopId);
    futureCustomer = ApiService().fetchMenuItems(widget.shopId);
    // fetchShopDetails();
  }

  void updateGrandTotal() {
    setState(() {
      //grandTotal = total.values.fold(0, (sum, total) => sum + (total ?? 0));
      grandTotal = total.values.fold(0, (sum, value) => sum + value);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Order',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColors.primaryColor,
        ),
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          child: Form(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<UserModel>>(
                  future: futureCustomer,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text(''));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final menuItems = snapshot.data!;
                      return Container(
                        alignment: Alignment.center,
                        width: 380,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 13,
                            ),
                            Icon(
                              Icons.person,
                              color: MyColors.primaryColor,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: 300,
                              child: DropdownButtonFormField<String>(
                                  value: selectedItem,
                                  // Initially, this can be null

                                  hint: Text(
                                      'Select Customer                                  '),
                                  // Placeholder before selection

                                  items: menuItems.map((menuItems) {
                                    return DropdownMenuItem<String>(
                                      value: menuItems
                                          .name, // Assigning the item id as value
                                      child: Text(
                                        maxLines: 1,
                                        menuItems.name.toString(),
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis),
                                      ), // Displaying the item name
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedItem = newValue;
                                      name = selectedItem.toString();
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a customer';
                                    }
                                  }),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                FutureBuilder<List<Menuitem>>(
                  future: futurermenu,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            MyColors.primaryColor),
                        strokeWidth: 5.0,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final menuItems = snapshot.data!;
                      return Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: MyColors.primaryColor),
                                      SizedBox(width: 8),
                                      Text(
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Table(columnWidths: {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                            }, children: [
                              TableRow(
                                children: [
                                  Text("ITEM",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text("QUANTITY",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text("PRICE(₹)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ]),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: menuItems.length,
                              itemBuilder: (context, index) {
                                List menulist = menuItems;
                                return Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              menulist[index].menuname ?? '',
                                              style: TextStyle(fontSize: 16)),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  quantities[menulist[index]
                                                      .id] = (quantities[
                                                              menulist[index]
                                                                  .id] ??
                                                          0) -
                                                      1;
                                                  if (quantities[
                                                          menulist[index].id]! <
                                                      0)
                                                    quantities[
                                                        menulist[index].id] = 0;
                                                  int a = int.parse(
                                                      menulist[index]
                                                          .menuprice);
                                                  total[menulist[index].id] =
                                                      a *
                                                          quantities[
                                                              menulist[index]
                                                                  .id]!;
                                                  updateGrandTotal();
                                                });

                                                // Update daily quantity
                                              },
                                            ),
                                            Text(
                                              (quantities[menulist[index].id] ??
                                                      0)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  quantities[menulist[index]
                                                      .id] = (quantities[
                                                              menulist[index]
                                                                  .id] ??
                                                          0) +
                                                      1;
                                                  int a = int.parse(
                                                      menulist[index]
                                                          .menuprice);
                                                  total[menulist[index].id] =
                                                      a *
                                                          quantities[
                                                              menulist[index]
                                                                  .id]!;
                                                  updateGrandTotal();
                                                });

                                                // Update daily quantity
                                              },
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text('X',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  '   ${menulist[index].menuprice} =',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                              Text(
                                                  (total[menulist[index].id] ??
                                                          0)
                                                      .toString(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Total: ", style: TextStyle(fontSize: 18)),
                                Text("₹ ${grandTotal}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.green)),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    backgroundColor: MyColors.primaryColor,
                                    foregroundColor: Colors.white),
                                onPressed: () {
                                  // Validate if a customer is selected
                                  if (selectedItem == null ||
                                      selectedItem!.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Please select a customer before placing an order."),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  if (grandTotal == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Please add items to the order."),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // Prepare order details
                                  amount = grandTotal.toString();
                                  status = 'NO';
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                  String formattedTime =
                                      DateFormat('hh:mm a').format(now);
                                  date = formattedDate;
                                  time = formattedTime;
                                  int largestValue = quantities.values
                                      .reduce((a, b) => a > b ? a : b);
                                  Insertuser();
                                  updateDailyQuantity(largestValue);

                                  // Reset values after placing the order
                                  setState(() {
                                    selectedItem = null;
                                    quantities.clear();
                                    total.clear();
                                    grandTotal = 0;
                                  });

                                  // Show success toast
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Order placed successfully!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: Text('Place Order',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Insertuser() {
    var url = Uri.parse("https://prakrutitech.buzz/Dhaval/insert_bill.php");
    http.post(url, body: {
      "name": selectedItem.toString(),
      "amount": amount,
      "time": time,
      "date": date,
      "status": status,
      "shopid": shopId
    });
  }

  Future<void> initializeDailyQuantity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get today's date as a key
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Initialize if not present
    if (!prefs.containsKey(todayKey)) {
      await prefs.setInt(todayKey, 0); // Initialize with 0
    }
  }

  Future<void> updateDailyQuantity(int change) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Get current value and add the change
    int currentQuantity = prefs.getInt(todayKey) ?? 0;
    currentQuantity += change;

    // Prevent negative values
    if (currentQuantity < 0) currentQuantity = 0;

    // Save updated quantity
    await prefs.setInt(todayKey, currentQuantity);
  }
}
