import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/my_input.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/shop/ui/register_seller/verification_page.dart';
import 'package:flutter/material.dart';

class SellerInformation extends StatelessWidget {
  const SellerInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
          label: "Register as seller",
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            Navigator.pop(context);
          }),
      body: const BodyPage(),
    );
  }
}

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // spacing
          const SizedBox(height: 20),
          MyTextField(
            label: "Shop Name",
            hint: "",
            controller: _nameController,
            underlineColor: Colors.black,
          ),

          // spacing
          const SizedBox(height: 10),

          MyTextField(
            label: "Shop Email",
            hint: "",
            controller: _emailController,
            underlineColor: Colors.black,
          ),

          // spacing
          const SizedBox(height: 10),

          MyTextField(
            label: "Shop Phone Number",
            hint: "",
            controller: _numberController,
            underlineColor: Colors.black,
          ),

          // spacing
          const SizedBox(height: 30),

          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: MyButton(
              title: "Next",
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                navigateWithSlideTransition(
                    context: context, page: const VerificationPage());
              },
              widthFactor: 0.38,
            ),
          )
        ],
      ),
    );
  }
}
