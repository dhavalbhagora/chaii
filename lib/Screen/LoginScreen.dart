import 'dart:convert';

import 'package:chaii/Colors/Color.dart';
import 'package:chaii/Screen/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../HomeScreen.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Login to Chaii',
            style: TextStyle(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        backgroundColor: MyColors.primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: const Text(
                    'Please log in to your account.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final email = emailController.text.toString();
                      final password = passwordController.text.toString();
                      login(email, password);
                      getShopData();
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        fontSize: 16,
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('https://prakrutitech.buzz/Dhaval/login.php');

    // Make the POST request
    final response = await http.post(
      url,
      body: {"email": email, "password": password},
    );

    // Decode the JSON response
    final data = jsonDecode(response.body);

    if (data == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Fail")));
    } else {
      print('yes');
      String shopName =
          data[0]['shopname']; // Ensure your API response includes these keys
      String shopId = data[0]['shopid'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('shopName', shopName);
      await prefs.setString('shopId', shopId);
      var sharedpref = await SharedPreferences.getInstance();
      sharedpref.setBool(mychaiscreenState.KEYLOGIN, false);
      print('Shop Name Saved: $shopName');
      print('Shop ID Saved: $shopId');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    }
  }

  Future<void> getShopData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shopName = prefs.getString('shopName');
    String? shopId = prefs.getString('shopId');

    print('Retrieved Shop Name: $shopName');
    print('Retrieved Shop ID: $shopId');
  }
}
