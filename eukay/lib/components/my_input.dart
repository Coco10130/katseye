import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final String hint;
  final double widthFactor;
  final double height;
  final TextEditingController controller;
  final bool password;
  final bool email;
  final Color textColor;
  final Color backgroundColor;
  final Color hintColor;
  final Color cursorColor;

  const MyTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.backgroundColor = Colors.transparent,
    this.hintColor = Colors.black54,
    this.textColor = Colors.black,
    this.height = 85,
    this.widthFactor = 0.85,
    this.password = false,
    this.email = false,
    this.cursorColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.transparent,
      child: SizedBox(
        width: parentWidth * widthFactor,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Label
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
              ),
            ),

            // Spacing
            const SizedBox(height: 10),

            // Input field
            TextField(
              controller: controller,
              obscureText: password,
              keyboardType: email ? TextInputType.emailAddress : null,
              style: TextStyle(
                color: textColor,
                fontFamily: "Poppins",
              ),
              cursorColor: cursorColor,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: backgroundColor,
                hintStyle: TextStyle(
                  color: hintColor,
                  fontFamily: "Poppins",
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
