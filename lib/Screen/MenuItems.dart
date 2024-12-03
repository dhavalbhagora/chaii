import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../API/Api_getmenuitem.dart';
import '../Colors/Color.dart';
import '../Model/menuitem_model.dart';

class Menuitems extends StatefulWidget {
  final String shopId;

  const Menuitems({Key? key, required this.shopId}) : super(key: key);

  @override
  State<Menuitems> createState() => _MenuitemsState();
}

class _MenuitemsState extends State<Menuitems> {
  late Future<List<Menuitem>> futureMenuItems;
  TextEditingController menunameController = TextEditingController();
  TextEditingController menupriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureMenuItems = ApiServiceMenu().fetchMenuItems(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu Items',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder<List<Menuitem>>(
            future: futureMenuItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final menuItems = snapshot.data ?? [];
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
                        leading: CircleAvatar(
                          backgroundColor: MyColors.primaryColor,
                          child:
                              const Icon(Icons.fastfood, color: Colors.white),
                        ),
                        title: Text(
                          menuItems[index].menuname ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          "Price: ₹${menuItems[index].menuprice}",
                          style: const TextStyle(fontSize: 16),
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
        onPressed: _showAddMenuDialog,
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
            "Menu Management",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showAddMenuDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Menu Item"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: menunameController,
                    decoration: const InputDecoration(
                      labelText: 'Menu Item Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the item name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: menupriceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addMenuItem,
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

  Future<void> _addMenuItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse("https://prakrutitech.buzz/Dhaval/addmenuitem.php");
      final response = await http.post(url, body: {
        "menuname": menunameController.text,
        "menuprice": menupriceController.text,
        "shopid": widget.shopId,
      });

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Close the dialog
        _clearFormFields();
        setState(() {
          futureMenuItems = ApiServiceMenu().fetchMenuItems(widget.shopId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu item added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add menu item')),
        );
      }
    }
  }

  void _clearFormFields() {
    menunameController.clear();
    menupriceController.clear();
  }
}
