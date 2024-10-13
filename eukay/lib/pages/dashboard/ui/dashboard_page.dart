import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/buttons/category_text_button.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_searchbox.dart';
import 'package:eukay/components/product_cards/product_card.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/auth/ui/auth_page.dart';
import 'package:eukay/pages/cart/ui/cart_page.dart';
import 'package:eukay/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:eukay/pages/search/ui/search_page.dart';
import 'package:eukay/pages/search/ui/searched_page.dart';
import 'package:eukay/pages/search/ui/view_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late SharedPreferences pref;
  late String cartCount;
  String? token;
  String? userId;
  bool initializedToken = false;

  void onResetToken() {
    initPref().then((_) {
      initCartCount();
    });
  }

  Future<void> initPref() async {
    try {
      pref = await SharedPreferences.getInstance();
      setState(() {
        initializedToken = true;
        token = pref.getString("token") ?? "";
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void initCartCount() {
    if (token!.isNotEmpty) {
      final Map<String, dynamic> jwtDecocded = JwtDecoder.decode(token!);
      cartCount = jwtDecocded["cartItems"].toString();
      userId = jwtDecocded["id"].toString();
    }
  }

  void fetchProducts() {
    context.read<DashboardBloc>().add(FetchProductsInitialEvent());
  }

  @override
  void initState() {
    super.initState();
    initPref().then((_) {
      initCartCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initializedToken) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Pocket Picks",
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
          token! != ""
              ? Stack(
                  children: [
                    Positioned(
                      right: 15,
                      child: Text(
                        cartCount,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: const ImageIcon(
                          AssetImage("assets/icons/shopping-cart.png"),
                          size: 24,
                          color: Color(0xFFFFFFFF),
                        ),
                        onPressed: () {
                          initializedToken = false;
                          navigateWithSlideTransition(
                              context: context,
                              page: CartPage(
                                token: pref.getString("token")!,
                              ),
                              onFetch: () {
                                onResetToken();
                                fetchProducts();
                              });
                        },
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: MyButton(
                    title: "Sign in",
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    widthFactor: 0.20,
                    fontSize: 12,
                    height: 40,
                    verticalPadding: 5,
                    onPressed: () {
                      navigateWithSlideTransition(
                        context: context,
                        page: const AuthPage(),
                        onFetch: () => onResetToken(),
                      );
                    },
                  ),
                ),
        ],
      ),
      body: DashboardBody(
        fetchProfile: () => onResetToken(),
        userId: userId,
        onFetchProduct: fetchProducts,
      ),
    );
  }
}

class DashboardBody extends StatefulWidget {
  final String? userId;
  final VoidCallback fetchProfile;
  final VoidCallback onFetchProduct;
  const DashboardBody(
      {super.key,
      this.userId,
      required this.fetchProfile,
      required this.onFetchProduct});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  @override
  void initState() {
    super.initState();
    widget.onFetchProduct();
  }

  Future<void> refresh() async {
    widget.onFetchProduct();
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
          return Center(
            child:
                LoadingScreen(color: Theme.of(context).colorScheme.onSecondary),
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
          return SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: refresh,
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
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      hintColor: Theme.of(context).colorScheme.onSecondary,
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
                      height: 50,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          // shirt label
                          CategoryTextButton(
                            label: "Shirts",
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            textColor:
                                Theme.of(context).colorScheme.onSecondary,
                            onPressed: () {
                              navigateWithSlideTransition(
                                context: context,
                                page: const SearchedPage(
                                  itemCategory: "Shirts",
                                ),
                              );
                            },
                          ),

                          // spacing
                          const SizedBox(
                            width: spacing - 5,
                          ),

                          // shorts label
                          CategoryTextButton(
                            label: "Shorts",
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            textColor:
                                Theme.of(context).colorScheme.onSecondary,
                            onPressed: () {
                              navigateWithSlideTransition(
                                context: context,
                                page: const SearchedPage(
                                  itemCategory: "Shorts",
                                ),
                              );
                            },
                          ),

                          // spacing
                          const SizedBox(
                            width: spacing - 5,
                          ),

                          // mens label
                          CategoryTextButton(
                            label: "Men",
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            textColor:
                                Theme.of(context).colorScheme.onSecondary,
                            onPressed: () {
                              navigateWithSlideTransition(
                                context: context,
                                page: const SearchedPage(
                                  genderCategory: "Men",
                                ),
                              );
                            },
                          ),

                          // spacing
                          const SizedBox(
                            width: spacing - 5,
                          ),

                          // Womens label
                          CategoryTextButton(
                            label: "Women",
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            textColor:
                                Theme.of(context).colorScheme.onSecondary,
                            onPressed: () {
                              navigateWithSlideTransition(
                                context: context,
                                page: const SearchedPage(
                                  genderCategory: "Women",
                                ),
                              );
                            },
                          ),

                          // spacing
                          const SizedBox(
                            width: spacing - 5,
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
                          onPressed: () {
                            navigateWithSlideTransition(
                                context: context,
                                page: ViewProduct(
                                  productId: product.id,
                                ),
                                onFetch: () => widget.fetchProfile());
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }
}
