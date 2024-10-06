import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/inputs/my_input.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/pages/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterEmailPage extends StatefulWidget {
  final String? email;
  const EnterEmailPage({super.key, required this.email});

  @override
  State<EnterEmailPage> createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.email != null && widget.email!.isNotEmpty) {
      _emailController.text = widget.email!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double spacing = 10;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingScreen(
              color: Theme.of(context).colorScheme.onSecondary);
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // enter email label
              Text(
                "Enter Email",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),

              // spacing
              const SizedBox(height: spacing),

              // enter email indicator
              Text(
                "Please enter your email to reset password",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),

              // spacing
              const SizedBox(height: spacing + 5),

              // email input
              MyTextField(
                label: "Your Email",
                hint: "Enter Your Email",
                controller: _emailController,
                underlineColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),

              // spacing
              const SizedBox(height: spacing),

              // submit button
              MyButton(
                title: "Submit",
                backgroundColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  context.read<AuthBloc>().add(
                        SendOtpEvent(email: _emailController.text),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
