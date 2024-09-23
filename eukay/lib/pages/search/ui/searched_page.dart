import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_searchbox.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/product_cards/product_card.dart';
import 'package:eukay/pages/search/bloc/search_bloc.dart';
import 'package:eukay/pages/search/ui/view_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SearchedPage extends StatelessWidget {
  final String searchPrompt;
  const SearchedPage({super.key, required this.searchPrompt});

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
            label: searchPrompt,
            hintColor: Theme.of(context).colorScheme.onSecondary,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SearchedBody(prompt: searchPrompt),
    );
  }
}

class SearchedBody extends StatefulWidget {
  final String prompt;
  const SearchedBody({super.key, required this.prompt});

  @override
  State<SearchedBody> createState() => _SearchedBodyState();
}

class _SearchedBodyState extends State<SearchedBody> {
  void fetchSearchProducts() {
    context
        .read<SearchBloc>()
        .add(FetchSearchedProductEvent(searchPrompt: widget.prompt));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridItemWidth = screenWidth > 1200 ? 300 : screenWidth * 0.4;

    final int crossAxisCount = (screenWidth / gridItemWidth).floor();
    final double productSpacing = screenWidth > 1200 ? 50 : 10;

    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchProductFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(mySnackBar(
            errorMessage: state.errorMessage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.error,
          ));
        }
      },
      builder: (context, state) {
        if (state is SearchProductSuccessEmptyState) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        }
        if (state is SearchProductSuccessState) {
          final products = state.products;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 1200 ? 500 : 20,
                vertical: 10,
              ),
              child: GridView.builder(
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
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    onPressed: () async {
                      final response =
                          await Get.to(ViewProduct(productId: product.id));

                      if (response == true) {
                        fetchSearchProducts();
                      }
                    },
                  );
                },
              ),
            ),
          );
        }
        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }
}
