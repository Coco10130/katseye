import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/navigate_to_auth.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/cart/ui/cart_page.dart';
import 'package:eukay/pages/shop/ui/shop_pages/add_product.dart';
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
  late String role = "";
  late String cartCount = "0";

  Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("token") ?? "";
      initializedPref = true;

      if (token.isNotEmpty) {
        final Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token);
        role = jwtDecoded["role"];
        cartCount = jwtDecoded["cartItems"].toString();
      }
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "My Shop",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        actions: [
          // Show cart action button if logged in
          if (token.isNotEmpty) ...[
            Stack(
              children: [
                Positioned(
                  right: 15,
                  child: Text(
                    cartCount,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    icon: const ImageIcon(
                      AssetImage("assets/icons/shopping-cart.png"),
                      size: 24,
                      color: Color(0xFFFFFFFF),
                    ),
                    onPressed: () {
                      navigateWithSlideTransition(
                        context: context,
                        page: CartPage(
                          token: token,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: token.isEmpty
          ? NavigateAuthButtons(
              textColor: Theme.of(context).colorScheme.onSecondary,
              buttonTextColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            )
          : (role == "seller"
              ? SellerPage(token: token)
              : const NonSellerPage()),
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
