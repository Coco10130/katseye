import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String title;
  final Color textColor;
  final VoidCallback onPressed;
  const MyTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.textColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}
