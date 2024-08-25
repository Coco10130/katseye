import 'package:flutter/material.dart';

AppBar MyAppBar({
  required String label,
  required VoidCallback onPressed,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
}) {
  return AppBar(
    title: Text(
      label,
      style: TextStyle(
        fontSize: 24,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    ),
    centerTitle: true,
    backgroundColor: backgroundColor,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onPressed,
    ),
  );
}
