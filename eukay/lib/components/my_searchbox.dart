import 'package:flutter/material.dart';

class MySeach extends StatelessWidget {
  final String label;
  final double widthFactor;
  final Color backgroundColor;
  const MySeach(
      {super.key,
      required this.label,
      this.widthFactor = 0.9,
      this.backgroundColor = const Color(0xFF373737)});

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
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontFamily: "Poppins",
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
    );
  }
}
