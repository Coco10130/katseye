import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/pages/shop/ui/shop_pages/seller_page.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "My Shop",
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: const SellerPage(),
    );
  }
}
