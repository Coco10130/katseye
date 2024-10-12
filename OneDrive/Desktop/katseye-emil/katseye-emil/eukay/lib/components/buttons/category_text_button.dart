import 'package:flutter/material.dart';

class CategoryTextButton extends StatelessWidget {
  final String label;
  final Color backgroundColor, textColor;
  final double height, width;
  final VoidCallback onPressed;

  const CategoryTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF373737),
    this.height = 50,
    this.width = 100,
    this.textColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
        ));
  }
}
