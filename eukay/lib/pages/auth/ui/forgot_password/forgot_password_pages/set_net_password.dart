import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/inputs/my_input.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/pages/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetNewPassword extends StatefulWidget {
  final String email;
  final bool otpVerified;
  const SetNewPassword(
      {super.key, required this.email, required this.otpVerified});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double spacing = 20;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingScreen(
              color: Theme.of(context).colorScheme.onSecondary);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // set password label
              Text(
                "Set new password",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // spacing
              const SizedBox(height: spacing),

              // sub label
              Text(
                "Create a new password, Ensure it differs from the previous one for security",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),

              // spacing
              const SizedBox(height: spacing),

              // password input
              MyTextField(
                label: "Password",
                hint: "Enter new password",
                underlineColor: Theme.of(context).colorScheme.onSecondary,
                controller: _newPasswordController,
                password: true,
              ),

              // spacing
              const SizedBox(height: spacing),

              // confirm password input
              MyTextField(
                label: "Confirm Password",
                hint: "Confirm new password",
                underlineColor: Theme.of(context).colorScheme.onSecondary,
                controller: _confirmPasswordController,
                password: true,
              ),

              // spacing
              const SizedBox(height: spacing),

              // update button
              MyButton(
                title: "Update Password",
                backgroundColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                borderRadius: 15,
                onPressed: () {
                  context.read<AuthBloc>().add(
                        ResetPasswordEvent(
                          newPassword: _newPasswordController.text,
                          confirmPassword: _confirmPasswordController.text,
                          email: widget.email,
                          otpVerified: widget.otpVerified,
                        ),
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
