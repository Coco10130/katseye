import 'package:eukay/components/buttons/my_text_button.dart';
import 'package:flutter/material.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/my_input.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onLoginTap;
  const RegisterPage({super.key, required this.onLoginTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // animation
  bool _isVisible = true;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loginTransition() {
    _scaleController.reverse().then((_) {
      setState(() {
        _isVisible = false;
      });
      widget.onLoginTap();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  "Create an Account",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),

                // spcaing
                const SizedBox(
                  height: spacing,
                ),

                // name input
                MyTextField(
                  label: "Name",
                  hint: "Your Name",
                  controller: _nameController,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // email input
                MyTextField(
                  label: "Email",
                  hint: "Your Email",
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
                  hint: "Your Password",
                  controller: _passwordController,
                  password: true,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // confirm password
                MyTextField(
                  label: "Confirm Password",
                  hint: "Confirm Password",
                  controller: _confirmPasswordController,
                  password: true,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // register button
                MyButton(
                  title: "Register",
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {},
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // back to login button
                MyTextButton(
                  title: "Alrady have an account? Login Here",
                  onPressed: _loginTransition,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),

                // spacing
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
