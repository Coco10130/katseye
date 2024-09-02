import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          label: "Register as seller",
          onPressed: () {
            Navigator.pop(context);
          }),
      body: const BodyPage(),
    );
  }
}

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  final List<TextEditingController> _codeController =
      List.generate(5, (index) => TextEditingController());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Text(
              "We sent a reset link to your email.\nEnter the 5-digit code mentioned in the email.",
              style: TextStyle(
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return SizedBox(
                width: 50,
                child: TextField(
                  controller: _codeController[index],
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (value) {
                    if (value.length == 1 && index < 4) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              );
            }),
          ),

          // spacing
          const SizedBox(
            height: 30,
          ),

          // buttons
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyButton(
                  title: "Back",
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  widthFactor: 0.30,
                ),
                MyButton(
                  title: "Submit",
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {},
                  widthFactor: 0.30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
