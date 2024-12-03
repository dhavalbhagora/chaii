import 'package:chaii/Colors/Color.dart';
import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final IconData? iconData;
  final String value;
  final double width;
  final double height;
  final VoidCallback onPress;

  //final String? lable;

  CustomMenu(
      {required this.value,
      required this.iconData,
      required this.width,
      required this.height,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        color: MyColors.white,
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: MyColors.primaryColor,
              ),
              //icon: Icon(iconData),
              //onPressed: () => print("a")),
              Text(
                value,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryColor),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
