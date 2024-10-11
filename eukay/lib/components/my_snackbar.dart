import 'package:flutter/material.dart';

SnackBar mySnackBar({
  required String message,
  Color backgroundColor = const Color(0xFFFFFFFF),
  Color textColor = const Color(0xFF000000),
}) {
  return SnackBar(
    duration: const Duration(seconds: 2),
    content: Center(
      child: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
