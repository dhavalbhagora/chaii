import 'package:flutter/material.dart';

import '../Colors/Color.dart';

class appbar extends StatelessWidget {
  final String title;

  const appbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Chaii',
        style: TextStyle(
            color: MyColors.white, fontWeight: FontWeight.bold, fontSize: 25),
      ),
      backgroundColor: MyColors.primaryColor,
    );
  }
}
