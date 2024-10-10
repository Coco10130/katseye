import 'package:eukay/components/appbar/my_tab_bar.dart';
import 'package:eukay/pages/shop/ui/sales/tabs/pending_page.dart';
import 'package:eukay/pages/shop/ui/sales/tabs/reviews_page.dart';
import 'package:eukay/pages/shop/ui/sales/tabs/to_deliver_page.dart';
import 'package:eukay/pages/shop/ui/sales/tabs/to_prepare_page.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatelessWidget {
  final int pending, toPrepare, toDeliver, reviews;
  final String sellerId;
  const SalesPage({
    super.key,
    required this.pending,
    required this.toPrepare,
    required this.toDeliver,
    required this.reviews,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text(
            "Sales",
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
              _tab("pending", pending),
              _tab("To Prepare", toPrepare),
              _tab("To Deliver", toDeliver),
              _tab("reviews", reviews),
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
        body: TabBarView(
          children: [
            PendingPage(
              sellerId: sellerId,
            ),
            ToPreparePage(
              sellerId: sellerId,
            ),
            ToDeliverPage(
              sellerId: sellerId,
            ),
            const ReviewsPage(),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, int count) {
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
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
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
