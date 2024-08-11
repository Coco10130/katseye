import 'package:eukay/pages/auth_page/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: const Text(
          "E-Ukay",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xFFA9A9A9),
        centerTitle: true,
      ),
      body: const LoginPage(),
    );
  }
}
