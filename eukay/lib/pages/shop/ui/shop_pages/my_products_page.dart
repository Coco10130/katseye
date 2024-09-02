import 'package:eukay/components/appbar/my_tab_bar.dart';
import 'package:eukay/pages/shop/ui/my_products/delisted_page.dart';
import 'package:eukay/pages/shop/ui/my_products/reviews_page.dart';
import 'package:eukay/pages/shop/ui/my_products/sold_out_products.dart';
import 'package:flutter/material.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text(
            "My Products",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: MyTabBar(
            tabs: [
              _tab("Live", "0"),
              _tab("Sold Out", "0"),
              _tab("Reviewing", "0"),
              _tab("Violation", "0"),
              _tab("Delisted", "0"),
            ],
            height: 70,
          ),
        ),
        body: const TabBarView(
          children: [
            SoldOutProducts(),
            ReviewsPage(),
            DelistedPage(),
            DelistedPage(),
            DelistedPage(),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Tab(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "($count)",
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
