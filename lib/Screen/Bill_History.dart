import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/api_getbill.dart';
import '../Colors/Color.dart';
import '../Model/bill_modal.dart';

class BillHistory extends StatefulWidget {
  final String shopId;
  const BillHistory({super.key, required this.shopId});

  @override
  State<BillHistory> createState() => _BillHistoryState();
}

class _BillHistoryState extends State<BillHistory> {
  late Future<List<BillModal>> futurebill;
  late String id;
  String selectedFilter = "ONLINE";
  String shopName = '';
  String shopId = '';
  String Mode = '';

  @override
  void initState() {
    super.initState();
    fetchShopDetails();
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
        title: const Text('Bill History'),
        backgroundColor: MyColors.primaryColor,
        foregroundColor: MyColors.white,
      ),
      backgroundColor: MyColors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Filter by Payment:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedFilter,
                  dropdownColor: MyColors.white,
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  items: ["ONLINE", "CASH"]
                      .map(
                        (filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(
                            filter,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<BillModal>>(
              future: futurebill,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ));
                } else {
                  List<BillModal> BillList = snapshot.data!;

                  if (selectedFilter != "All") {
                    BillList =
                        BillList.where((bill) => bill.status == selectedFilter)
                            .toList();
                  }

                  if (BillList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No bills found for the selected filter.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  BillList = BillList.reversed.toList();
                  return ListView.builder(
                    itemCount: BillList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            'Customer: ${BillList[index].name}'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primaryColor),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Amount: ₹${BillList[index].amount}',
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('Date: ${BillList[index].date}',
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('Time: ${BillList[index].time}',
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(
                                  'Payment Mode: ${BillList[index].status}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: BillList[index].status == "ONLINE"
                                        ? Colors.green
                                        : MyColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
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
}
