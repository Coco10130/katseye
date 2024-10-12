import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/auth/ui/auth_page.dart';
import 'package:flutter/material.dart';

class NavigateAuthButtons extends StatelessWidget {
  final Color textColor, backgroundColor, buttonTextColor;

  const NavigateAuthButtons(
      {super.key,
      this.textColor = Colors.black,
      this.buttonTextColor = Colors.black,
      this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // text to display that they need to sign in to access page
            Text(
              "You need to sign in to access this page",
              style: TextStyle(
                fontFamily: "Poppins",
                color: textColor,
                fontSize: 18,
              ),
            ),

            // spacing
            const SizedBox(
              height: 15,
            ),

            // sign in button
            MyButton(
              title: "Sign in",
              backgroundColor: backgroundColor,
              textColor: buttonTextColor,
              onPressed: () {
                navigateWithSlideTransition(
                  context: context,
                  page: const AuthPage(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
