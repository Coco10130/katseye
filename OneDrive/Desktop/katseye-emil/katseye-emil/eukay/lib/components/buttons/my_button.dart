import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Color backgroundColor, textColor;
  final VoidCallback onPressed;
  final double verticalPadding, elevation, fontSize, widthFactor, borderRadius;
  final double? height;
  final bool enabled;

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
    this.borderRadius = 20,
    this.height,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = parentWidth * widthFactor;

    return GestureDetector(
      onTap: enabled ? onPressed : () {},
      child: Container(
        width: buttonWidth,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
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
