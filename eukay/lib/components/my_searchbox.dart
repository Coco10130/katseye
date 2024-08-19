import 'package:flutter/material.dart';

class MySeach extends StatelessWidget {
  final String label;
  final double widthFactor;
  final Color backgroundColor;
  final Color textColor;
  final Color hintColor;
  const MySeach({
    super.key,
    required this.label,
    this.widthFactor = 0.9,
    this.backgroundColor = const Color(0xFF373737),
    this.textColor = const Color(0xFFFFFFFF),
    this.hintColor = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;
    final double width = parentWidth * widthFactor;

    return Center(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
        ),
        child: TextField(
          style: TextStyle(
            color: textColor,
            fontFamily: "Poppins",
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            hintStyle: TextStyle(
              color: hintColor,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
    );
  }
}
