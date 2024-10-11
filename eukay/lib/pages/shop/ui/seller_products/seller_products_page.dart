import 'package:eukay/components/appbar/my_tab_bar.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:eukay/pages/shop/ui/seller_products/tabs/delisted_page.dart';
import 'package:eukay/pages/shop/ui/seller_products/tabs/live_products.dart';
import 'package:eukay/pages/shop/ui/seller_products/tabs/sold_out_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProducts extends StatefulWidget {
  final String sellerId, token;
  const MyProducts({
    super.key,
    required this.sellerId,
    required this.token,
  });

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  int live = 0;
  int soldOut = 0;
  int delisted = 0;

  Future<void> fetchSellerProfile() async {
    context.read<ShopBloc>().add(FetchSellerProfileEvent(token: widget.token));
  }

  @override
  void initState() {
    super.initState();
    fetchSellerProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is FetchSellerSuccessState) {
          final seller = state.seller;
          setState(() {
            live = seller.live;
            soldOut = seller.soldOut;
            delisted = seller.delisted;
          });
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
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
                  _tab("Live", live),
                  _tab("Sold Out", soldOut),
                  _tab("Delisted", delisted),
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
                LivePage(
                  sellerId: widget.sellerId,
                  token: widget.token,
                ),
                SoldOutProducts(
                  sellerId: widget.sellerId,
                  token: widget.token,
                ),
                DelistedPage(
                  sellerId: widget.sellerId,
                  token: widget.token,
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
