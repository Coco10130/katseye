import 'package:eukay/components/appbar/my_tab_bar.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/to_prepage_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/to_rate_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/to_recieve_page.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  final int initialIndex;
  const OrdersPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialIndex,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text(
            "My Orders",
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
              _tab("To Prepare"),
              _tab("To Recieve"),
              _tab("To Rate"),
            ],
            height: 70,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: const TabBarView(
          children: [
            ToPrepareUser(),
            ToRecieve(),
            ToRate(),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label) {
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
          ],
        ),
      ),
    );
  }
}
