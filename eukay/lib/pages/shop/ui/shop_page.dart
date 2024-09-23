import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/shop/ui/my_products/add_product.dart';
import 'package:eukay/pages/shop/ui/shop_pages/non_seller_page.dart';
import 'package:eukay/pages/shop/ui/shop_pages/seller_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late SharedPreferences pref;
  bool initializedPref = false;
  late String token;
  late String role;

  Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("token") ?? "";
      initializedPref = true;
      final Map<String, dynamic> jwtDecocded = JwtDecoder.decode(token);
      role = jwtDecocded["role"];
    });
  }

  @override
  void initState() {
    super.initState();
    initPref();
  }

  @override
  Widget build(BuildContext context) {
    if (!initializedPref) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "My Shop",
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),

      // TODO: ADD LOGIC IF THE TOKEN IS NULL, ADD BUTTON TO NAVIGATE IN AUTH PAGE
      body: role == "seller"
          ? SellerPage(
              token: token,
            )
          : const NonSellerPage(),
      floatingActionButton: role == "seller"
          ? FloatingActionButton(
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
            )
          : null,
    );
  }
}
