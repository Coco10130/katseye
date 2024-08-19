import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/my_input.dart';
import 'package:eukay/components/buttons/my_text_button.dart';
import 'package:eukay/pages/main_pages/dashboard_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onRegisterTap;
  const LoginPage({super.key, required this.onRegisterTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // input controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // animation controllers
  bool _isVisible = false;
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
    parent: _scaleController,
    curve: Curves.easeOut,
  ));

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });

      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _registerTransition() {
    _scaleController.reverse().then((_) {
      setState(() {
        _isVisible = false;
      });
      widget.onRegisterTap();
    });
  }

  void _login() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DashboardPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // screen size
    final double screenWidth = MediaQuery.of(context).size.width;
    const double spacing = 10;

    return Center(
      child: SingleChildScrollView(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: screenWidth * 0.9,
            height: _isVisible ? null : 0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // card title
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // email input
                MyTextField(
                  label: "Email",
                  hint: "Enter Email",
                  controller: _emailController,
                  email: true,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // password input
                MyTextField(
                  label: "Password",
                  hint: "Enter Password",
                  controller: _passwordController,
                  password: true,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: MyTextButton(
                    title: "Forgot Password",
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {},
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // login button
                MyButton(
                  title: "Login",
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: _login,
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // divider
                Text(
                  "OR",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // register button
                MyButton(
                  title: "Register",
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: _registerTransition,
                ),

                // padding bottom
                const SizedBox(
                  height: spacing,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
