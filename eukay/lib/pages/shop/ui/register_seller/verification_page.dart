import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/inputs/otp_input.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/navigation_menu.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationPage extends StatelessWidget {
  final String shopEmail, shopContact, shopName, token, otpHash;
  const VerificationPage({
    super.key,
    required this.shopEmail,
    required this.shopContact,
    required this.shopName,
    required this.token,
    required this.otpHash,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          label: "Register as seller",
          onPressed: () {
            Navigator.pop(context);
          }),
      body: BodyPage(
        otpHash: otpHash,
        shopContact: shopContact,
        shopEmail: shopEmail,
        shopName: shopName,
        token: token,
      ),
    );
  }
}

class BodyPage extends StatefulWidget {
  final String shopEmail, shopContact, shopName, token, otpHash;
  const BodyPage(
      {super.key,
      required this.shopEmail,
      required this.shopContact,
      required this.shopName,
      required this.token,
      required this.otpHash});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  final TextEditingController _otpController = TextEditingController();
  late SharedPreferences pref;

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  Future<void> updateToken(String newToken) async {
    pref = await SharedPreferences.getInstance();
    await pref.setString("token", newToken);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) async {
        if (state is RegisterShopSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              errorMessage: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );

          await updateToken(state.token);

          Get.offAll(const NavigationMenu());
        }

        if (state is RegisterShopFailedState) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              errorMessage: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ShopLoadingState) {
          return LoadingScreen(
              color: Theme.of(context).colorScheme.onSecondary);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // spacing
              const SizedBox(
                height: 100,
              ),

              // otp input
              OtpInput(
                labelText:
                    "We sent a reset link to your email.\nEnter the 4-digit code mentioned in the email.",
                controller: _otpController,
              ),

              // spacing
              const SizedBox(
                height: 30,
              ),

              // buttons
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyButton(
                      title: "Back",
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.onSecondary,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      widthFactor: 0.30,
                    ),
                    MyButton(
                      title: "Submit",
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        context.read<ShopBloc>().add(RegisterShopEvent(
                            otpCode: _otpController.text,
                            otpHash: widget.otpHash,
                            shopContact: widget.shopContact,
                            shopName: widget.shopName,
                            token: widget.token,
                            shopEmail: widget.shopEmail));
                      },
                      widthFactor: 0.30,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
