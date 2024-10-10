import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/containers/order_shipping_address_container.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/product_cards/order_summary_cards.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/check_out/bloc/check_out_bloc.dart';
import 'package:eukay/pages/check_out/mappers/order_model.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/profile/ui/profile_pages/shipping_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "Order Summary",
        textColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: const BodyPage(),
    );
  }
}

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  bool initializedPref = false;
  String? token;
  late SharedPreferences pref;
  int totalSellers = 0;
  String? userId;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    initPref().then((_) {
      fetchOrders();
      fetchUserAddress();
    });
  }

  void fetchOrders() {
    context.read<CheckOutBloc>().add(FetchOrderSummaryEvent(token: token!));
  }

  void fetchUserAddress() {
    context
        .read<ProfileBloc>()
        .add(FetchDeliveryAddressEvent(token: token!, userId: userId!));
  }

  Future<void> changeToken(String token) async {
    try {
      await pref.clear();
      pref.setString("token", token);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> initPref() async {
    try {
      pref = await SharedPreferences.getInstance();
      setState(() {
        token = pref.getString("token");
        final Map<String, dynamic> jwtDecocded = JwtDecoder.decode(token!);
        userId = jwtDecocded["id"].toString();
        initializedPref = true;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Map<String, List<OrderModel>> groupedProductsBySeller(
      List<OrderModel> cartItems) {
    final Map<String, List<OrderModel>> groupedProducts = {};

    for (var item in cartItems) {
      if (item.sellerName.isNotEmpty) {
        if (groupedProducts.containsKey(item.sellerName)) {
          groupedProducts[item.sellerName]!.add(item);
        } else {
          groupedProducts[item.sellerName] = [item];
        }
      } else {
        // Handle cases where sellerId is null or empty
        throw Exception(
            "Item with null or empty seller name: ${item.productName}");
      }
    }

    return groupedProducts;
  }

  @override
  Widget build(BuildContext context) {
    const double spacing = 10;

    if (!initializedPref) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }
    return BlocConsumer<CheckOutBloc, CheckOutState>(
      listener: (context, state) {
        if (state is FetchCheckOutFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );

          fetchOrders();
        } else if (state is CheckOutFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );

          fetchOrders();
        } else if (state is CheckOutSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );

          changeToken(state.newToken);
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        if (state is FetchCheckOutSuccessState) {
          final products = state.products;
          final groupedProducts = groupedProductsBySeller(products);
          totalSellers = groupedProducts.keys.length;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: totalSellers,
                    itemBuilder: (context, index) {
                      final sellerName = groupedProducts.keys.elementAt(index);
                      final product = groupedProducts[sellerName]!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          color: Theme.of(context).colorScheme.onSurface,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // shop name
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  sellerName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // product(s)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: product.length,
                                itemBuilder: (context, productIndex) {
                                  final item = product[productIndex];
                                  return OrderSummaryProductContainer(
                                    image: item.productImage,
                                    productName: item.productName,
                                    quantity: item.quantity,
                                    price: item.subTotal,
                                    size: item.size,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    textColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // spacing
                const SizedBox(height: spacing),

                // display shipping information
                GestureDetector(
                  onTap: () {
                    navigateWithSlideTransition(
                      context: context,
                      page: const ShippingAddress(),
                      onFetch: fetch,
                    );
                  },
                  child: const OrderShippingAddressContainer(),
                ),

                // spacing
                const SizedBox(height: spacing),

                // payment method
                Container(
                  width: double.infinity,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // payment method label
                      Text(
                        "Payment Method",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 17,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // spacing
                      const SizedBox(height: spacing),

                      // cod text
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "COD",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // spacing
                const SizedBox(height: spacing),

                // total price report
                _navigation(products, totalSellers),
              ],
            ),
          );
        }
        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }

  Widget _navigation(List<OrderModel> products, int totalSellers) {
    const double spacing = 10;

    double subTotal = 0;
    for (var product in products) {
      subTotal += product.subTotal;
    }
    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱ ",
    );
    const int shippingFee = 30;
    int totalShippingFee = shippingFee * totalSellers;
    double totalPrice = totalShippingFee + subTotal;

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        color: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // sub total
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // sub total label
                  Text(
                    "Sub Total",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // sub total
                  Text(
                    formatCurrency.format(subTotal),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // spacing
            const SizedBox(height: spacing),

            // shipping fee
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // sub total label
                  Text(
                    "Shipping Fee",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    formatCurrency.format(totalShippingFee),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // spacing
            const SizedBox(height: spacing + 10),

            // total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // sub total label
                Text(
                  "Total: ${formatCurrency.format(totalPrice)}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 17,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // button
                MyButton(
                  title: "Continue",
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  verticalPadding: 10,
                  widthFactor: 0.30,
                  onPressed: () {
                    context
                        .read<CheckOutBloc>()
                        .add(CheckOutOrdersEvent(token: token!));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
