import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../API/Api_getuser.dart';
import '../Colors/Color.dart';
import '../Model/usermodel.dart';

class AddCustomer extends StatefulWidget {
  final String shopId;
  const AddCustomer({Key? key, required this.shopId}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  late Future<List<UserModel>> futureCustomer;
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureCustomer = ApiService().fetchMenuItems(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: MyColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCustomerList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder<List<UserModel>>(
            future: futureCustomer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final customers = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: customers.length,
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
                        title: Text(
                          customers[index].name?.toUpperCase() ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contact: ${customers[index].contact}'),
                            Text('Address: ${customers[index].address}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCustomerDialog,
        backgroundColor: MyColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: MyColors.primaryColor,
        child: Container(
          height: 60.0,
          alignment: Alignment.center,
          child: const Text(
            "Add Customer",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _refreshCustomerList() {
    setState(() {
      futureCustomer = ApiService().fetchMenuItems(widget.shopId);
    });
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Customer"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: contactController,
                    decoration: const InputDecoration(labelText: 'Contact'),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      final pattern = r'^[6-9]\d{9}$';
                      final regExp = RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Please enter a contact number';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addCustomer,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
              ),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCustomer() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse("https://prakrutitech.buzz/Dhaval/insert.php");
      final response = await http.post(url, body: {
        "contact": contactController.text,
        "address": addressController.text,
        "name": nameController.text,
        "shopid": widget.shopId,
      });

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Close the dialog
        _refreshCustomerList(); // Refresh customer list
        _clearForm(); // Clear form fields
      } else {
        // Handle API error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add customer.')),
        );
      }
    }
  }

  void _clearForm() {
    nameController.clear();
    contactController.clear();
    addressController.clear();
  }
}
