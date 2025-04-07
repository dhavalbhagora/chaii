import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

void main() {
  runApp(MaterialApp(
    home: mychaiscreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class mychaiscreen extends StatefulWidget {
  const mychaiscreen({super.key});

  @override
  State<mychaiscreen> createState() => mychaiscreenState();
}

class mychaiscreenState extends State<mychaiscreen> {
  static const String KEYLOGIN = 'login';
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {
      // After 3 seconds, navigate to the home screen
      WhereGoTO();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/image.png'), // Your splash image
      ),
    );
  }

  void WhereGoTO() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isloggedin = sharedpref.getBool(KEYLOGIN);

    Timer(Duration(seconds: 3), () {
      if (isloggedin == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homescreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homescreen()));
      }
    });
  }
}
