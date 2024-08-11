import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final String hint;
  final double widthFactor;
  final double height;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.height = 85,
    this.widthFactor = 0.85,
  });

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.transparent, // Transparent background
      child: SizedBox(
        width: parentWidth * widthFactor,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Label
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 15,
                fontFamily: "Poppins",
              ),
            ),

            // Spacing
            const SizedBox(height: 10),

            // Input field
            TextField(
              controller: controller,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontFamily: "Poppins",
              ),
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: const Color(0xFF373737),
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                ),
                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
