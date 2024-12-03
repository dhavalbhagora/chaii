import 'package:chaii/Colors/Color.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String value;
  final String lable;
  final IconData? iconData;
  final double width;
  final double height;
  CustomCard(
      {required this.value,
      required this.lable,
      required this.width,
      required this.height,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyColors.primaryColor,
      child: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MyColors.white),
            ),
            SizedBox(height: 10),
            Text(
              lable,
              style: TextStyle(color: MyColors.white, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
