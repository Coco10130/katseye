import 'package:eukay/navigation_menu.dart';
import 'package:eukay/pages/auth/bloc/auth_bloc.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/my_input.dart';
import 'package:eukay/components/buttons/my_text_button.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences prefs;

  // animation controllers
  bool _isVisible = false;
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
    parent: _scaleController,
    curve: Curves.fastEaseInToSlowEaseOut,
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
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
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

  @override
  Widget build(BuildContext context) {
    // screen size
    final double screenWidth = MediaQuery.of(context).size.width;
    const double spacing = 10;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              errorMessage: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        }

        if (state is AuthLoginSuccess) {
          final myToken = state.token.toString();
          prefs.setString("token", myToken);
          Get.to(
            () => NavigationMenu(
              token: myToken,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        color: Theme.of(context).colorScheme.onSecondary,
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
                      textColor: Theme.of(context).colorScheme.onSecondary,
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
                      textColor: Theme.of(context).colorScheme.onSecondary,
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
                        textColor: Theme.of(context).colorScheme.onSecondary,
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
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              AuthLoginRequest(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                      },
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
                        color: Theme.of(context).colorScheme.onSecondary,
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
      },
    );
  }
}
