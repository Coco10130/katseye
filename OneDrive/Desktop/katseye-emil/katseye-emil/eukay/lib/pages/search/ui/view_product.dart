import 'package:carousel_slider/carousel_slider.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/containers/product_review_container.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/auth/ui/auth_page.dart';
import 'package:eukay/pages/cart/ui/cart_page.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/dashboard/mappers/review_model.dart';
import 'package:eukay/pages/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProduct extends StatefulWidget {
  final String productId;
  const ViewProduct({super.key, required this.productId});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  bool isLikedByUser = false;
  bool initializedToken = false;
  late SharedPreferences pref;
  late String cartCount;
  String? token;
  String? userId;

  @override
  void initState() {
    super.initState();
    initPref().then((_) {
      initToken();
    });
  }

  void onSignIn() {
    initPref().then((_) {
      initToken();
    });
  }

  void initToken() {
    if (token!.isNotEmpty) {
      final Map<String, dynamic> jwtDecocded = JwtDecoder.decode(token!);
      userId = jwtDecocded["id"].toString();
    }
  }

  void checkIfLiked(List<String> wishedByUser) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (token!.isNotEmpty) {
        setState(() {
          isLikedByUser = wishedByUser.contains(userId!);
        });
      }
    });
  }

  void initCartCount() {
    if (token!.isNotEmpty) {
      final Map<String, dynamic> jwtDecocded = JwtDecoder.decode(token!);
      setState(() {
        cartCount = jwtDecocded["cartItems"].toString();
        userId = jwtDecocded["id"].toString();
      });
    }
  }

  Future<void> initPref() async {
    try {
      pref = await SharedPreferences.getInstance();
      setState(() {
        token = pref.getString("token") ?? "";
        initCartCount();
        initializedToken = true;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> removeWishlist(String productId) async {
    context
        .read<SearchBloc>()
        .add(RemoveWishlistEvent(productId: productId, token: token!));
  }

  Future<void> addWishlist(String productId) async {
    context
        .read<SearchBloc>()
        .add(AddWishlistEvent(productId: productId, token: token!));
  }

  @override
  Widget build(BuildContext context) {
    if (!initializedToken) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          // cart action button
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                isLikedByUser ? Iconsax.heart5 : Iconsax.heart,
                color: isLikedByUser ? Colors.red : Colors.white,
                size: 25,
              ),
              onPressed: token!.isNotEmpty
                  ? () {
                      isLikedByUser
                          ? removeWishlist(widget.productId)
                          : addWishlist(widget.productId);
                    }
                  : () {
                      navigateWithSlideTransition(
                        context: context,
                        page: const AuthPage(),
                        onFetch: () => onSignIn(),
                      );
                    },
            ),
          ),

          if (token!.isNotEmpty) ...[
            Stack(
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
                      navigateWithSlideTransition(
                          context: context,
                          page: CartPage(
                            token: pref.getString("token")!,
                          ),
                          onFetch: () {
                            () => onSignIn();
                          });
                    },
                  ),
                ),
              ],
            )
          ]
        ],
      ),
      body: BodyPage(
        onSignIn: () => onSignIn(),
        productId: widget.productId,
        userId: userId ?? "",
        onProductFetched: checkIfLiked,
      ),
    );
  }
}

class BodyPage extends StatefulWidget {
  final String productId;
  final String? userId;
  final Function(List<String>) onProductFetched;
  final VoidCallback onSignIn;
  const BodyPage(
      {super.key,
      required this.productId,
      required this.onProductFetched,
      required this.onSignIn,
      this.userId});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  late SharedPreferences pref;
  String selectedSize = "";
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initPreference();
    fetchProduct();
  }

  Future<void> initPreference() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> updateToken(String newToken) async {
    await pref.clear();
    await pref.setString("token", newToken);
  }

  void fetchProduct() {
    context
        .read<SearchBloc>()
        .add(FetchViewProductEvent(productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets edgePadding = EdgeInsets.symmetric(horizontal: 15);
    const double spacing = 10;

    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is ViewProductFailedState) {
          // if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is WishlistSuccessState) {
          // if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );
          fetchProduct();
        } else if (state is WishlistFailedState) {
          // if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
          fetchProduct();
        }

        if (state is AddToCartFailedState) {
          // if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(mySnackBar(
            message: state.errorMessage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.error,
          ));
        }

        if (state is AddToCartSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(mySnackBar(
            message: state.successMessage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onSecondary,
          ));
          updateToken(state.token).then((_) {
            widget.onSignIn();
          });
          fetchProduct();
        }
      },
      builder: (context, state) {
        if (state is ViewProductSuccessState) {
          final product = state.product;
          final List<ReviewModel> reviews = product.reviews;
          final List<SizeQuantity> sizeQuantities = product.sizeQuantities;

          final List<Map<String, dynamic>> extractedReviews =
              reviews.map((review) {
            return {
              'userName': review.userName,
              'starRating': review.starRating,
              'userImage': review.userImage,
              'review': review.review,
            };
          }).toList();
          final List<String> sizes =
              sizeQuantities.map((sq) => sq.size).toList();
          widget.onProductFetched(product.wishedByUser);
          final List<String> images = product.productImage.take(5).toList();
          final formatCurrency = NumberFormat.currency(
            locale: "en_PH",
            symbol: "₱ ",
          );
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product image
                CarouselSlider(
                  options: CarouselOptions(
                    height: 350,
                    enableInfiniteScroll: false,
                    autoPlayInterval: const Duration(seconds: 10),
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                  items: images.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )),
                        );
                      },
                    );
                  }).toList(),
                ),

                // spacing
                const SizedBox(
                  height: spacing + 10,
                ),

                // product name
                Padding(
                  padding: edgePadding,
                  child: Text(
                    product.productName,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
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
                        "${product.rating} ( ${product.reviews.length} REVIEWS )",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // description label
                Padding(
                  padding: edgePadding,
                  child: Text(
                    "DESCRIPTION:",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing - 5,
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
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing + 10,
                ),

                // size label
                Padding(
                  padding: edgePadding,
                  child: Text(
                    "Size:",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // display sizes
                Padding(
                  padding: edgePadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var size in sizes) _size(size),
                    ],
                  ),
                ),

                // spacing
                const SizedBox(
                  height: spacing + 10,
                ),

                // buy and add to cart buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    width: double.infinity,
                    height: 49,
                    child: Stack(
                      children: [
                        // display price
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              formatCurrency.format(product.price),
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // add to cart button
                        Positioned(
                          right: 0,
                          child: MyButton(
                            title: "Add to Cart",
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            widthFactor: 0.35,
                            fontSize: 14,
                            verticalPadding: 16,
                            onPressed: () async {
                              if (widget.userId!.isEmpty) {
                                return navigateWithSlideTransition(
                                  context: context,
                                  page: const AuthPage(),
                                  onFetch: fetchProduct,
                                );
                              }

                              if (selectedSize.isNotEmpty) {
                                context.read<SearchBloc>().add(
                                      AddToCartEvent(
                                        productId: state.product.id,
                                        size: selectedSize,
                                        token: pref.getString("token")!,
                                      ),
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  mySnackBar(
                                    message: "Select size",
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    textColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // spacing
                const SizedBox(height: 20),

                // reviews
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: extractedReviews.length,
                  itemBuilder: (context, index) {
                    final review = extractedReviews[index];
                    return ProductReviewContainer(
                        image: review["userImage"],
                        reviewMessage: review["review"],
                        name: review["userName"],
                        starRating: review["starRating"]);
                  },
                )
              ],
            ),
          );
        }
        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }

  Widget _size(String size) {
    bool selected = size == selectedSize;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSize = selected ? "" : size;
          });
        },
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            color: selected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
