import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_searchbox.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/product_cards/product_card.dart';
import 'package:eukay/pages/search/bloc/search_bloc.dart';
import 'package:eukay/pages/search/ui/view_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchedPage extends StatelessWidget {
  final String? searchPrompt, genderCategory, itemCategory;
  const SearchedPage({
    super.key,
    this.searchPrompt,
    this.genderCategory,
    this.itemCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: MySeach(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: 8,
            label: searchPrompt ?? "",
            hintColor: Theme.of(context).colorScheme.onSecondary,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: SearchedBody(
        prompt: searchPrompt,
        genderCategory: genderCategory,
        itemCategory: itemCategory,
      ),
    );
  }
}

class SearchedBody extends StatefulWidget {
  final String? prompt, genderCategory, itemCategory;
  const SearchedBody({
    super.key,
    this.prompt,
    this.genderCategory,
    this.itemCategory,
  });

  @override
  State<SearchedBody> createState() => _SearchedBodyState();
}

class _SearchedBodyState extends State<SearchedBody> {
  String? selectedGenderCategory;
  String? selectedItemCategory;
  String? selectedRatings;
  String? selectedPriceRanges;

  final List<String> genderCategory = [
    "Gender Category",
    "Men",
    "Women",
  ];

  final List<String> itemCategory = [
    "Item Category",
    "Pants",
    "Shoes",
    "Shirts",
    "Shorts",
    "Long Sleeves",
    "Cap",
    "Hoodie",
    "Belt",
    "Suits",
    "Blouse",
    "Dress",
  ];

  final List<String> ratings = [
    "Ratings",
    "1 Star",
    "2 Stars",
    "3 Stars",
    "4 Stars",
    "5 Stars",
  ];

  final List<String> priceRange = [
    "Price Range",
    "1-99",
    "100-199",
    "200-299",
    "400-499",
    "Above 500",
  ];

  Future<void> fetchSearchProducts() async {
    context.read<SearchBloc>().add(
          FetchSearchedProductEvent(
            searchPrompt: widget.prompt,
            category: selectedItemCategory,
            gender: selectedGenderCategory,
            priceRange: selectedPriceRanges,
            ratings: selectedRatings,
          ),
        );
  }

  Future<void> initCategories() async {
    setState(() {
      selectedGenderCategory = widget.genderCategory;
      selectedItemCategory = widget.itemCategory;
    });
  }

  @override
  void initState() {
    super.initState();
    initCategories().then((_) {
      fetchSearchProducts();
    });
  }

  @override
  void dispose() {
    selectedGenderCategory = null;
    selectedItemCategory = null;
    selectedRatings = null;
    selectedPriceRanges = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridItemWidth = screenWidth > 1200 ? 300 : screenWidth * 0.4;

    final int crossAxisCount = (screenWidth / gridItemWidth).floor();
    final double productSpacing = screenWidth > 1200 ? 50 : 10;

    return Column(
      children: [
        // search filter

        SizedBox(
          height: 50,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              // side spacing
              const SizedBox(width: 5),
              SizedBox(
                width: 120,
                child: _dropDownMenu(
                  hint: "Gender Category",
                  items: genderCategory,
                  selectedItem: selectedGenderCategory,
                  onChanged: (value) {
                    setState(() {
                      if (value == "Gender Category") {
                        selectedGenderCategory = null;
                      } else {
                        selectedGenderCategory = value;
                      }
                      fetchSearchProducts();
                    });
                  },
                ),
              ),

              // spacing
              const SizedBox(width: 5),

              SizedBox(
                width: 120,
                child: _dropDownMenu(
                  hint: "Item Category",
                  items: itemCategory,
                  selectedItem: selectedItemCategory,
                  onChanged: (value) {
                    setState(() {
                      if (value == "Item Category") {
                        selectedItemCategory = null;
                      } else {
                        selectedItemCategory = value;
                      }
                      fetchSearchProducts();
                    });
                  },
                ),
              ),

              // spacing
              const SizedBox(width: 5),

              SizedBox(
                width: 110,
                child: _dropDownMenu(
                  hint: "Ratings",
                  items: ratings,
                  selectedItem: selectedRatings,
                  onChanged: (value) {
                    setState(() {
                      if (value == "Ratings") {
                        selectedRatings = null;
                      } else {
                        selectedRatings = value;
                      }
                      fetchSearchProducts();
                    });
                  },
                ),
              ),

              // spacing
              const SizedBox(width: 5),

              SizedBox(
                width: 110,
                child: _dropDownMenu(
                  hint: "Price Range",
                  items: priceRange,
                  selectedItem: selectedPriceRanges,
                  onChanged: (value) {
                    setState(() {
                      if (value == "Price Range") {
                        selectedPriceRanges = null;
                      } else {
                        selectedPriceRanges = value;
                      }
                      fetchSearchProducts();
                    });
                  },
                ),
              ),

              // side spacing
              const SizedBox(width: 5),
            ],
          ),
        ),
        BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchProductFailedState) {
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
            if (state is SearchProductSuccessEmptyState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              );
            }
            if (state is SearchProductSuccessState) {
              final products = state.products;
              return RefreshIndicator(
                onRefresh: () => fetchSearchProducts(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // items
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth > 1200 ? 500 : 20,
                          vertical: 10,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                              textColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              onPressed: () async {
                                final response = await Get.to(
                                    ViewProduct(productId: product.id));

                                if (response == true) {
                                  fetchSearchProducts();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return LoadingScreen(
                color: Theme.of(context).colorScheme.onSecondary);
          },
        ),
      ],
    );
  }

  Widget _dropDownMenu({
    required String hint,
    required List<String> items,
    String? selectedItem,
    required ValueChanged<String?> onChanged,
  }) {
    return Center(
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: 12,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        value: selectedItem,
        icon: Icon(
          Iconsax.arrow_down_1,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 15,
        ),
        elevation: 16,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
        underline: Container(
          height: 2,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: "Poppins",
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
