import 'package:chaii/Colors/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- Import url_launcher

import '../API/Api_getuser.dart';
import '../Model/usermodel.dart';

class CustomerList extends StatefulWidget {
  final String shopId;
  const CustomerList({super.key, required this.shopId});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late Future<List<UserModel>> futureCustomer;

  @override
  void initState() {
    super.initState();
    futureCustomer = ApiService().fetchMenuItems(widget.shopId);
  }

  // Function to launch phone dialer
  void launchPhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    final Uri uri = Uri.parse(phoneNumber);

    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not place call to $phoneNumber')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        backgroundColor: MyColors.primaryColor,
        foregroundColor: MyColors.white,
      ),
      backgroundColor: MyColors.white,
      body: FutureBuilder<List<UserModel>>(
        future: futureCustomer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final menuItems = snapshot.data!;
            return ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    textColor: MyColors.primaryColor,
                    tileColor: Colors.white,
                    title: Text(
                      "Name: ${menuItems[index].name?.toUpperCase()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact: ${menuItems[index].contact}',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            'Address: ${menuItems[index].address}',
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Call the customer when phone icon is pressedurl
                            String url = menuItems[index].contact!.toString();
                            // launchPhoneCall('$url');

                            FlutterPhoneDirectCaller.callNumber('$url');
                          },
                          icon: Icon(Icons.phone),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
