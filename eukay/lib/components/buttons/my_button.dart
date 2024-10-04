import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Color backgroundColor, textColor;
  final VoidCallback onPressed;
  final double widthFactor;
  final double verticalPadding, elevation, fontSize;
  final double? height;

  const MyButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onPressed,
    this.textColor = const Color(0xFFFFFFFF),
    this.widthFactor = 0.85,
    this.verticalPadding = 15,
    this.elevation = 0,
    this.fontSize = 15,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = parentWidth * widthFactor;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: fontSize,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
