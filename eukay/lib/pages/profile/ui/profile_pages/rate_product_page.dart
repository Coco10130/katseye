import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/product_cards/rate_product_card.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RateProductPage extends StatefulWidget {
  final String productId, productName, size, productImage, token, orderId, id;
  final double price;

  const RateProductPage({
    super.key,
    required this.productId,
    required this.orderId,
    required this.productName,
    required this.size,
    required this.productImage,
    required this.id,
    required this.price,
    required this.token,
  });

  @override
  State<RateProductPage> createState() => _RateProductPageState();
}

class _RateProductPageState extends State<RateProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "Rate",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: BodyPage(
        orderId: widget.orderId,
        price: widget.price,
        id: widget.id,
        productId: widget.productId,
        productImage: widget.productImage,
        productName: widget.productName,
        size: widget.size,
        token: widget.token,
      ),
    );
  }
}

class BodyPage extends StatefulWidget {
  final String productId, productName, size, productImage, token, orderId, id;
  final double price;
  const BodyPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.orderId,
    required this.id,
    required this.size,
    required this.productImage,
    required this.price,
    required this.token,
  });

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is AddReviewProductFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is AddReviewProductSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return LoadingScreen(
              color: Theme.of(context).colorScheme.onSecondary);
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: RateProductCard(
                    price: widget.price,
                    productImage: widget.productImage,
                    productName: widget.productName,
                    size: widget.size,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),

                const SizedBox(height: 20),

                // Star rating row
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFA534),
                          size: 40,
                        ),
                        onPressed: () => _setRating(index + 1),
                      );
                    }),
                  ),
                ),

                // rate product label
                Center(
                  child: Text(
                    "Rate this product",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // write a review label
                Text(
                  "Write a review",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 10),

                // Multi-line text input for review
                TextField(
                  controller: _reviewController,
                  maxLines: 5,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontFamily: "Poppins",
                  ),
                  decoration: InputDecoration(
                    hintText: "Write your review here...",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontFamily: "Poppins",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),

                const SizedBox(height: 20),

                // Submit button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      final String review = _reviewController.text.trim();
                      if (review.isEmpty && _rating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          mySnackBar(
                            message: "Please provide a review and a rating",
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      } else {
                        context.read<ProfileBloc>().add(
                              AddReviewProductEvent(
                                orderId: widget.orderId,
                                productId: widget.productId,
                                id: widget.id,
                                review: review,
                                starRating: _rating,
                                token: widget.token,
                              ),
                            );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Submit Review",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
