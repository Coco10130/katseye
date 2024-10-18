import 'package:flutter/material.dart';

AppBar MyAppBar({
  required String label,
  VoidCallback? onPressed,
  bool leading = false,
  bool centerTile = true,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  List<Widget>? actions,
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
    centerTitle: centerTile,
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: false,
    leading: onPressed != null
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onPressed,
          )
        : null,
    actions: actions,
  );
}
