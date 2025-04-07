import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../API/api_getbill.dart';
import '../Colors/Color.dart';
import '../Model/bill_modal.dart';

class GenerateOder extends StatefulWidget {
  final String shopId;
  const GenerateOder({super.key, required this.shopId});

  @override
  State<GenerateOder> createState() => _GenerateOderState();
}

class _GenerateOderState extends State<GenerateOder> {
  late Future<List<BillModal>> futurebill;
  late String id;
  String shopName = 'Tea & Food Point';
  String shopId = '20';
  String Mode = '';

  @override
  void initState() {
    // super.initState();
    //  fetchShopDetails();
    futurebill = ApiServiceBill().fetchBill(widget.shopId);
  }

  Future<void> fetchShopDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      shopName = prefs.getString('shopName') ?? 'No Shop Name';
      shopId = prefs.getString('shopId') ?? 'No Shop ID';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generate Bill',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: MyColors.primaryColor,
      ),
      backgroundColor: MyColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Header Section

          Text(
            'Shop Name :- $shopName',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor),
          ),
          Expanded(
            child: FutureBuilder<List<BillModal>>(
              future: futurebill,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:
                        CircularProgressIndicator(color: MyColors.primaryColor),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  final bills = snapshot.data!
                      .where((bill) => bill.status == 'NO')
                      .toList();
                  if (bills.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox,
                              size: 80, color: MyColors.primaryColor),
                          SizedBox(height: 10),
                          Text(
                            'No pending bills found.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: bills.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          id = bills[index].id.toString();
                          billStatus(id);

                          print("Long pressed on bill: ${bills[index].name}");
                        },
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: Icon(Icons.receipt,
                                color: MyColors.primaryColor, size: 40),
                            title: Text(
                              'Customer: ${bills[index].name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              'Date: ${bills[index].date}\nTime: ${bills[index].time}\nTotal: ₹${bills[index].amount}',
                            ),
                            // trailing: Column(
                            //   children: [
                            //     ElevatedButton.icon(
                            //       onPressed: () {
                            //         id = bills[index].id.toString();
                            //         billStatus(id);
                            //         initState();
                            //       },
                            //       icon: Icon(Icons.paid, color: Colors.white),
                            //       label: Text(
                            //         "MAKE BILL",
                            //         style: TextStyle(color: Colors.white),
                            //       ),
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: MyColors.primaryColor,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void billStatus(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Generate Bill",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Select payment mode:"),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Mode = 'ONLINE';
                        Updatebill();
                        setState(() {
                          futurebill =
                              ApiServiceBill().fetchBill(widget.shopId);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.online_prediction,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Online",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Mode = 'CASH';
                        Updatebill();
                        setState(() {
                          futurebill =
                              ApiServiceBill().fetchBill(widget.shopId);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Cash",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Cencal",
                        style: TextStyle(color: Colors.white),
                      ),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        deletebill();
                        setState(() {
                          futurebill =
                              ApiServiceBill().fetchBill(widget.shopId);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void Updatebill() {
    var url = Uri.parse("https://prakrutitech.buzz/Dhaval/updatebill.php");
    http.post(url, body: {"id": id, "status": Mode.toString()});
  }

  void deletebill() {
    var url = Uri.parse("https://prakrutitech.buzz/Dhaval/deletebill.php");
    http.post(url, body: {"id": id});
  }
}
