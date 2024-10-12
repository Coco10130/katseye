import 'package:eukay/components/appbar/my_tab_bar.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/completed_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/pending_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/to_prepage_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/order_history.dart';
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
      length: 5,
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
              _tab("Pending"),
              _tab("To Prepare"),
              _tab("To Recieve"),
              _tab("Delivered"),
              _tab("Order History"),
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
            PendingPage(),
            ToPrepareUser(),
            ToRecieve(),
            CompletedPage(),
            OrderHistory(),
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
              softWrap: false,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
