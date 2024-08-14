import 'package:flutter/material.dart';

class MyIconBUtton extends StatelessWidget {
  final String icon;
  final Color backgroundColor;
  final double height;
  final double width;
  final Color iconColor;

  const MyIconBUtton({
    super.key,
    required this.icon,
    this.backgroundColor = const Color(0xFF373737),
    this.height = 50,
    this.width = 50,
    this.iconColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () {
          // Perform your action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
        ),
        child: Image.asset(
          icon,
          width: 30,
          height: 30,
          color: iconColor,
        ),
      ),
    );
  }
}
