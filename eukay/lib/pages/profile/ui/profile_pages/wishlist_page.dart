import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/product_cards/product_card.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/search/ui/view_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wishlist extends StatelessWidget {
  final String userId;
  const Wishlist({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "wishlists",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: BodyPage(userId: userId),
    );
  }
}

class BodyPage extends StatefulWidget {
  final String userId;
  const BodyPage({super.key, required this.userId});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  late SharedPreferences pref;
  bool prefInitialized = false;
  String? token;

  @override
  void initState() {
    super.initState();
    initPref().then((_) {
      fetchWishlists();
    });
  }

  Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
      prefInitialized = true;
    });
  }

  void fetchWishlists() {
    context.read<ProfileBloc>().add(FetchUserWishlistsEvent(token: token!));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridItemWidth = screenWidth > 1200 ? 300 : screenWidth * 0.4;

    final int crossAxisCount = (screenWidth / gridItemWidth).floor();
    final double productSpacing = screenWidth > 1200 ? 50 : 10;

    if (!prefInitialized) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is WishListFailedState) {
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
        if (state is WishListSuccessState) {
          final products = state.products;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: productSpacing,
                mainAxisSpacing: productSpacing,
                childAspectRatio: screenWidth > 1200 ? 0.81 : 0.77,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  discount: product.discount,
                  name: product.productName,
                  image: product.productImage[0],
                  price: product.price,
                  shop: "Shop: ${product.sellerName}",
                  rating: product.rating,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  onPressed: () async {
                    final response = await Get.to(
                      ViewProduct(
                        productId: product.id,
                      ),
                    );

                    if (response == true) {
                      fetchWishlists();
                    }
                  },
                );
              },
            ),
          );
        }
        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }
}
