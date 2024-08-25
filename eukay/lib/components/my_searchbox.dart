import 'package:flutter/material.dart';

class MySeach extends StatelessWidget {
  final String label;
  final double widthFactor;
  final Color backgroundColor, hintColor, textColor;
  final VoidCallback onPressed;
  final double? height;
  final double padding;
  const MySeach({
    super.key,
    required this.label,
    required this.onPressed,
    this.widthFactor = 0.9,
    this.backgroundColor = const Color(0xFF373737),
    this.textColor = const Color(0xFFFFFFFF),
    this.hintColor = Colors.white54,
    this.height,
    this.padding = 12,
  });

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;
    final double width = parentWidth * widthFactor;

    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: backgroundColor,
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: hintColor,
              ),

              // spacing
              const SizedBox(
                width: 5,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                  fontFamily: "Poppins",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
