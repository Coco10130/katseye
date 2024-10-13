import 'package:eukay/components/appbar/my_tab_bar.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/completed_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/pending_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/reviews_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/to_prepage_page.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/order_history.dart';
import 'package:eukay/pages/profile/ui/orders/tabs/to_recieve_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatefulWidget {
  final String token;
  final int initialIndex;
  const OrdersPage({
    super.key,
    required this.token,
    this.initialIndex = 0,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int pending = 0;
  int toPrepare = 0;
  int toRecieve = 0;
  int delivered = 0;
  int completeOrders = 0;
  int reviews = 0;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    context
        .read<ProfileBloc>()
        .add(ProfileInitialFetchEvent(token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is FetchProfileSuccessState) {
          final profile = state.profile;

          setState(() {
            pending = profile.pendingOrders;
            toPrepare = profile.prepareOrders;
            toRecieve = profile.deliverOrders;
            delivered = profile.deliveredOrders;
            completeOrders = profile.completeOrders;
            reviews = profile.reviews;
          });
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 6,
          initialIndex: widget.initialIndex,
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
                  _tab("Pending", pending),
                  _tab("To Prepare", toPrepare),
                  _tab("To Recieve", toRecieve),
                  _tab("Delivered", delivered),
                  _tab("Order History", completeOrders),
                  _tab("Reviews", reviews),
                ],
                isScrollable: true,
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
                UserReviewPage(),
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
