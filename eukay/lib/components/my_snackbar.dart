import 'package:flutter/material.dart';

SnackBar mySnackBar({
  required String errorMessage,
  Color backgroundColor = const Color(0xFFFFFFFF),
  Color textColor = const Color(0xFF000000),
}) {
  return SnackBar(
    content: Text(
      errorMessage,
      style: TextStyle(
        color: textColor,
        fontFamily: "Poppins",
      ),
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
