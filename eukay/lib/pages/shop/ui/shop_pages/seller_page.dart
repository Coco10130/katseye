import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:eukay/pages/shop/ui/shop_pages/my_products_page.dart';
import 'package:eukay/pages/shop/ui/widgets/products_by_seller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerPage extends StatefulWidget {
  final String token;
  const SellerPage({super.key, required this.token});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  late SharedPreferences pref;
  @override
  void initState() {
    super.initState();
    fetchSellerProfile();
    initPref();
  }

  Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  void fetchSellerProfile() {
    context.read<ShopBloc>().add(FetchSellerProfileEvent(token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is FetchSellerFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is FetchSellerSuccessState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // shop details
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Row(
                      children: [
                        // image
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(state.seller.image),
                        ),

                        // spacing
                        const SizedBox(
                          width: 10,
                        ),

                        // shop name
                        Text(
                          state.seller.shopName,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // spacing
                  const SizedBox(
                    height: 10,
                  ),

                  // order status
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order Status",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    "View Sales History",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                  ),

                                  // spacing
                                  const SizedBox(
                                    width: 10,
                                  ),

                                  const Icon(Iconsax.arrow_right_3)
                                ],
                              ),
                            )
                          ],
                        ),

                        // spacing
                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _myBox(
                              "Pending",
                              "${state.seller.pendingOrders}",
                              Theme.of(context).colorScheme.onSecondary,
                            ),
                            _myBox(
                              "To Prepare",
                              "${state.seller.prepareOrders}",
                              Theme.of(context).colorScheme.onSecondary,
                            ),
                            _myBox(
                              "To Deliver",
                              "${state.seller.deliverOrders}",
                              Theme.of(context).colorScheme.onSecondary,
                            ),
                            _myBox(
                              "Reviews",
                              "${state.seller.reviewOrders}",
                              Theme.of(context).colorScheme.onSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // spacing
                  const SizedBox(
                    height: 10,
                  ),
                  // my product label
                  GestureDetector(
                    onTap: () {
                      navigateWithSlideTransition(
                        context: context,
                        page: MyProducts(
                          sellerId: state.seller.id,
                          token: pref.getString("token")!,
                        ),
                        onFetch: fetchSellerProfile,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "My Products",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(Iconsax.arrow_right_3)
                        ],
                      ),
                    ),
                  ),

                  // spacing
                  const SizedBox(
                    height: 20,
                  ),

                  // display products of seller
                  ProductsBySeller(products: state.seller.products)
                ],
              ),
            ),
          );
        }
        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }

  Widget _myBox(String label, String count, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),

          // spacing
          const SizedBox(
            height: 10,
          ),

          Text(
            label,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
