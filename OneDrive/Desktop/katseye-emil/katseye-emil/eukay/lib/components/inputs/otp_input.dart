import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class OtpInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Color textColor, borderColor;
  const OtpInput({
    super.key,
    required this.labelText,
    required this.controller,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          Text(
            "Check Your Email",
            style: TextStyle(
              color: textColor,
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // spacing

          const SizedBox(
            height: 10,
          ),

          // sub label
          Text(
            labelText,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          // spacing
          const SizedBox(
            height: 20,
          ),

          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                controller: controller,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  label: Text(
                    "Enter OTP",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(
                    Iconsax.lock4,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
