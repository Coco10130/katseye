import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/shop/ui/my_products/add_product.dart';
import 'package:eukay/pages/shop/ui/shop_pages/non_seller_page.dart';
import 'package:eukay/pages/shop/ui/shop_pages/seller_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ShopPage extends StatelessWidget {
  final String token;
  const ShopPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> jwtDecocded = JwtDecoder.decode(token);
    final String role = jwtDecocded["role"];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "My Shop",
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: role == "seller"
          ? SellerPage(
              token: token,
            )
          : const NonSellerPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          navigateWithSlideTransition(
            context: context,
            page: const AddProduct(),
          );
        },
        tooltip: "Add New Product",
        child: const Icon(
          Iconsax.add_circle,
          size: 35,
        ),
      ),
    );
  }
}
