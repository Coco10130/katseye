import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/pages/auth/bloc/auth_bloc.dart';
import 'package:eukay/pages/auth/ui/forgot_password/forgot_password_pages/enter_email.dart';
import 'package:eukay/pages/auth/ui/forgot_password/forgot_password_pages/enter_otp.dart';
import 'package:eukay/pages/auth/ui/forgot_password/forgot_password_pages/set_net_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  int currentPage = 0;
  bool otpVerified = false;
  String? otpHash;
  String? email;

  void nextPage() {
    setState(() {
      currentPage += 1;
    });
  }

  void backPage() {
    setState(() {
      currentPage -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SendOtpSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );

          setState(() {
            otpHash = state.otpHash;
            email = state.email;
          });

          nextPage();
        } else if (state is ForgotPasswordFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is VerifyOtpSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );

          setState(() {
            otpVerified = true;
          });

          nextPage();
        } else if (state is ResetPasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          appBar: MyAppBar(
            label: "Forgot Password",
            backgroundColor: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          body: getCurrentPage(),
        );
      },
    );
  }

  Widget getCurrentPage() {
    switch (currentPage) {
      case 0:
        return EnterEmailPage(
          email: email,
        );
      case 1:
        return OtpInputPge(
          email: email!,
          onNext: nextPage,
          onBack: backPage,
          otphash: otpHash!,
        );
      case 2:
        return SetNewPassword(
          otpVerified: otpVerified,
          email: email!,
        );
      default:
        return Center(
          child: Text(
            "Page not found",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontFamily: "Poppins",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }
}
