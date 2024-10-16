import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String label, hint;
  final List<TextInputFormatter>? inputFormatters;
  final double widthFactor, height;
  final TextEditingController controller;
  final bool password, email, enabled;
  final double fontSize;
  final Color textColor,
      underlineColor,
      backgroundColor,
      hintColor,
      cursorColor;

  const MyTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.inputFormatters,
    this.backgroundColor = Colors.transparent,
    this.hintColor = Colors.black54,
    this.textColor = Colors.black,
    this.height = 85,
    this.widthFactor = 0.85,
    this.fontSize = 16,
    this.password = false,
    this.email = false,
    this.enabled = true,
    this.cursorColor = Colors.black,
    this.underlineColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;

    return Container(
      width: parentWidth * widthFactor,
      height: height,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Label
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),

          // Spacing
          const SizedBox(height: 10),

          // Input field
          TextField(
            enabled: enabled,
            controller: controller,
            obscureText: password,
            keyboardType: email ? TextInputType.emailAddress : null,
            style: TextStyle(
              color: textColor,
              fontFamily: "Poppins",
            ),
            cursorColor: cursorColor,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: backgroundColor,
              hintStyle: TextStyle(
                color: hintColor,
                fontFamily: "Poppins",
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: underlineColor),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: underlineColor),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: underlineColor),
                borderRadius: BorderRadius.circular(20),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
