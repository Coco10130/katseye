import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/pages/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

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
  @override
  void initState() {
    super.initState();
    fetchProduct();
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

  Widget _size(String size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.5,
          color: const Color(0xFF252525),
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 20,
        child: Text(
          size,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "Poppins"),
        ),
      ),
    );
  }
}
