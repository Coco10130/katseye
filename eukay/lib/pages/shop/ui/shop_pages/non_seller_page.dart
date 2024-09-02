import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/shop/ui/register_seller/seller_information.dart';
import 'package:flutter/material.dart';

import '../../../../components/buttons/my_button.dart';

class NonSellerPage extends StatelessWidget {
  const NonSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // spacing
          const SizedBox(
            height: 20,
          ),

          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "To get started, register as a seller by providing the necessary information",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
          ),
          MyButton(
            title: "Register as seller",
            backgroundColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              navigateWithSlideTransition(
                  context: context, page: const SellerInformation());
            },
          )
        ],
      ),
    );
  }
}
