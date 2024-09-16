import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/pages/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProduct extends StatelessWidget {
  final String productId;
  const ViewProduct({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: true);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          // cart action button
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(
                  Iconsax.heart,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {},
              )),
        ],
      ),
      body: BodyPage(productId: productId),
    );
  }
}

class BodyPage extends StatefulWidget {
  final String productId;
  const BodyPage({super.key, required this.productId});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  late SharedPreferences pref;
  @override
  void initState() {
    super.initState();
    initPreference();
    fetchProduct();
  }

  Future<void> initPreference() async {
    pref = await SharedPreferences.getInstance();
  }

  void fetchProduct() {
    context
        .read<SearchBloc>()
        .add(FetchViewProductEvent(productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets edgePadding = EdgeInsets.symmetric(horizontal: 10);
    const double spacing = 10;

    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is ViewProductFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(mySnackBar(
            errorMessage: state.errorMessage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.error,
          ));
        }

        if (state is AddToCartSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(mySnackBar(
            errorMessage: state.successMessage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onSecondary,
          ));
          fetchProduct();
        }
      },
      builder: (context, state) {
        if (state is ViewProductSuccessState) {
          final product = state.product;
          final formatCurrency = NumberFormat.currency(
            locale: "en_PH",
            symbol: "₱ ",
          );
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product image
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(product.productImage[0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // product name
                Padding(
                  padding: edgePadding,
                  child: Text(
                    product.productName,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // ratings
                Padding(
                  padding: edgePadding,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 0.7,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // star icon
                        const Icon(
                          Iconsax.star1,
                          color: Colors.amber,
                          size: 20,
                        ),

                        // spacing
                        const SizedBox(
                          width: 8,
                        ),

                        // rating score
                        Text(
                          "${product.rating}",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // description
                Padding(
                  padding: edgePadding,
                  child: Text(
                    product.productDescription,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // price
                Padding(
                  padding: edgePadding,
                  child: Text(
                    formatCurrency.format(product.price),
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing + 10,
                ),

                // seller details
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    "Seller Detail",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Sold by: ${product.sellerName}",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing + 10,
                ),

                // buy and add to cart buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: 270,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // buy now button
                        MyButton(
                          title: "Buy Now",
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          widthFactor: 0.30,
                          fontSize: 11,
                          onPressed: () {},
                        ),

                        // add to cart button
                        MyButton(
                          title: "Add to Cart",
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          widthFactor: 0.35,
                          fontSize: 11,
                          onPressed: () async {
                            context.read<SearchBloc>().add(AddToCartEvent(
                                productId: state.product.id,
                                token: pref.getString("token")!));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
