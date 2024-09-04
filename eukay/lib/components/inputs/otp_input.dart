import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class OtpInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  const OtpInput(
      {super.key, required this.labelText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Text(
            labelText,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // spacing
        const SizedBox(
          height: 20,
        ),

        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 150,
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
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
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
    );
  }
}
