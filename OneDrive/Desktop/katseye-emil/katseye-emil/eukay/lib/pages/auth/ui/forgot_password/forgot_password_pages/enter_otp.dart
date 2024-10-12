import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/inputs/otp_input.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/pages/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpInputPge extends StatefulWidget {
  final VoidCallback onNext, onBack;
  final String otphash, email;
  const OtpInputPge({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.otphash,
    required this.email,
  });

  @override
  State<OtpInputPge> createState() => _OtpInputPgeState();
}

class _OtpInputPgeState extends State<OtpInputPge> {
  final TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.email.isEmpty || widget.otphash.isEmpty) {
      return Center(
        child: Text(
          "Email or OTP hash is missing.",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingScreen(
              color: Theme.of(context).colorScheme.onSecondary);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // otp input
              OtpInput(
                labelText:
                    "We sent a reset link to your email. Enter the 4-digit code mentioned in the email.",
                controller: _otpController,
                borderColor: Theme.of(context).colorScheme.onSecondary,
              ),

              // spacing
              const SizedBox(height: 20),

              // submit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                      title: "Back",
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      widthFactor: 0.35,
                      borderRadius: 10,
                      onPressed: () {
                        widget.onBack();
                      }),
                  MyButton(
                    title: "Submit",
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    widthFactor: 0.35,
                    borderRadius: 10,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            VerifyOtpEvent(
                              email: widget.email,
                              otp: _otpController.text,
                              otpHash: widget.otphash,
                            ),
                          );
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
