import 'package:eukay/pages/auth_page/login_page.dart';
import 'package:eukay/pages/auth_page/register_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  bool _isLoginPage = true;

  void _showRegisterPage() {
    setState(() {
      _isLoginPage = false;
    });
  }

  void _showLoginPage() {
    setState(() {
      _isLoginPage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _isLoginPage
            ? LoginPage(onRegisterTap: _showRegisterPage)
            : RegisterPage(onLoginTap: _showLoginPage),
      ),
    );
  }
}
