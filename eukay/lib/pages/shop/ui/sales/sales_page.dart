import 'package:eukay/components/appbar/my_tab_bar.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:eukay/pages/shop/ui/sales/tabs/pending_page.dart';
import 'package:eukay/pages/shop/ui/sales/tabs/delivered_page.dart';
import 'package:eukay/pages/shop/ui/sales/tabs/to_deliver_page.dart';
import 'package:eukay/pages/shop/ui/sales/tabs/to_prepare_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesPage extends StatefulWidget {
  final String sellerId, token;
  const SalesPage({
    super.key,
    required this.sellerId,
    required this.token,
  });

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  int pending = 0;
  int reviews = 0;
  int toDeliver = 0;
  int toPrepare = 0;
  int delivered = 0;

  @override
  void initState() {
    super.initState();
    fetchSellerProfile();
  }

  Future<void> fetchSellerProfile() async {
    context.read<ShopBloc>().add(FetchSellerProfileEvent(token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is FetchSellerSuccessState) {
          final seller = state.seller;

          setState(() {
            pending = seller.pendingOrders;
            reviews = seller.reviewOrders;
            toDeliver = seller.deliverOrders;
            toPrepare = seller.prepareOrders;
            delivered = seller.deliveredOrders;
          });
        }
      },
      builder: (context, state) {
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
                  _tab("Delivered", delivered),
                ],
                height: 70,
                isScrollable: true,
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
                  sellerId: widget.sellerId,
                ),
                ToPreparePage(
                  sellerId: widget.sellerId,
                ),
                ToDeliverPage(
                  sellerId: widget.sellerId,
                ),
                DeliveredPage(
                  sellerId: widget.sellerId,
                ),
              ],
            ),
          ),
        );
      },
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
