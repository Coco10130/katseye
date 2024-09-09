import 'package:eukay/components/buttons/my_icon_button.dart';
import 'package:eukay/components/my_searchbox.dart';
import 'package:eukay/components/product_cards/product_card.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/cart/ui/cart_page.dart';
import 'package:eukay/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:eukay/pages/search/ui/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "E-Ukay",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        actions: [
          // cart action button
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const ImageIcon(
                AssetImage("assets/icons/shopping-cart.png"),
                size: 24,
                color: Color(0xFFFFFFFF),
              ),
              onPressed: () {
                navigateWithSlideTransition(
                  context: context,
                  page: const CartPage(),
                );
              },
            ),
          ),
        ],
      ),
      body: const DashboardBody(),
    );
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({
    super.key,
  });

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() {
    context.read<DashboardBloc>().add(FetchProductsInitialEvent());
  }

  Future<void> refresh() async {
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    const double spacing = 20;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridItemWidth = screenWidth > 1200 ? 300 : screenWidth * 0.4;

    final int crossAxisCount = (screenWidth / gridItemWidth).floor();
    final double productSpacing = screenWidth > 1200 ? 50 : 10;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DashboardFetchFailedState) {
          return Center(
            child: Text(
              "Failed to fetch products: ${state.errorMessage}",
              style: const TextStyle(color: Colors.black),
            ),
          );
        } else if (state is DashboardInitialFetchState) {
          final products = state.products;
          return RefreshIndicator(
            onRefresh: refresh,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth > 1200 ? 100 : 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // spacing
                    const SizedBox(
                      height: spacing,
                    ),
                    // search box
                    MySeach(
                      label: "Search product",
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        navigateWithSlideTransition(
                            context: context, page: const SearchPage());
                      },
                    ),
                    // spacing
                    const SizedBox(
                      height: spacing,
                    ),
                    // categories label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    // spacing
                    const SizedBox(
                      height: spacing,
                    ),
                    // display categories
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // shirt icon
                          MyIconBUtton(
                            icon: "assets/icons/tshirt.png",
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            iconColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                          // spacing
                          const SizedBox(
                            width: spacing + 10,
                          ),
                          // pants icon
                          MyIconBUtton(
                            icon: "assets/icons/trousers.png",
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            iconColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                          // spacing
                          const SizedBox(
                            width: spacing + 10,
                          ),
                          // shoe icon
                          MyIconBUtton(
                            icon: "assets/icons/tshirt.png",
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            iconColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                          // spacing
                          const SizedBox(
                            width: spacing + 10,
                          ),
                          // underwear icon
                          MyIconBUtton(
                            icon: "assets/icons/trousers.png",
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            iconColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                        ],
                      ),
                    ),
                    // spacing
                    const SizedBox(
                      height: spacing,
                    ),
                    // featured products label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Featured Products",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    // spacing
                    const SizedBox(
                      height: spacing,
                    ),
                    // display featured products
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: productSpacing,
                        mainAxisSpacing: productSpacing,
                        childAspectRatio: screenWidth > 1200 ? 0.81 : 0.74,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          name: product.productName,
                          image: product.productImage[0],
                          price: product.price,
                          shop: "Shop: ${product.sellerName}",
                          rating: product.rating,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          onPressed: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
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
