import 'dart:ui';

import 'package:eukay/components/my_button.dart';
import 'package:eukay/components/my_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVisible = true;
      });

      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // screen size
    final double screenWidth = MediaQuery.of(context).size.width;
    final double parentWidth = MediaQuery.of(context).size.width;
    final double lineWidth = parentWidth * 0.85;

    // input controllers
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Center(
      child: SingleChildScrollView(
        child: SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -2.0,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth * 0.9,
              height: _isVisible ? null : 0,
              decoration: const BoxDecoration(
                color: Color(0xFF373737),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // card title
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),

                  // spacing
                  const SizedBox(
                    height: 10,
                  ),

                  // email input
                  MyTextField(
                    label: "Email",
                    hint: "Enter Email",
                    controller: _emailController,
                  ),

                  // spacing
                  const SizedBox(
                    height: 10,
                  ),

                  MyTextField(
                    label: "Password",
                    hint: "Enter Password",
                    controller: _passwordController,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),

                  // spacing
                  const SizedBox(
                    height: 10,
                  ),

                  // login button
                  MyButton(
                    title: "Login",
                    backgroundColor: const Color(0xFF000000),
                    textColor: const Color(0xFFFFFFFF),
                    onPressed: () {},
                  ),

                  // spacing
                  const SizedBox(
                    height: 20,
                  ),

                  // divider
                  const Text(
                    "OR",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // spacing
                  const SizedBox(
                    height: 20,
                  ),

                  // register button
                  MyButton(
                    title: "Register",
                    backgroundColor: const Color(0xFFA9A9A9),
                    textColor: const Color(0xFF000000),
                    onPressed: () {},
                  ),

                  // padding bottom
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
