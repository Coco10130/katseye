import 'package:eukay/components/product_cards/live_product_card.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/shop/ui/shop_pages/update_product.dart';
import 'package:flutter/material.dart';

class ProductsBySeller extends StatelessWidget {
  final List<ProductModel> products;
  final VoidCallback onFetch;
  const ProductsBySeller({
    super.key,
    required this.products,
    required this.onFetch,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridItemWidth = screenWidth > 1200 ? 300 : screenWidth * 0.4;

    final int crossAxisCount = (screenWidth / gridItemWidth).floor();
    final double productSpacing = screenWidth > 1200 ? 50 : 10;

    if (products.isEmpty) {
      return Center(
        child: Text(
          "No Products Yet",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          final totalQuantity = product.sizeQuantities.fold<int>(
            0,
            (sum, size) => sum + size.quantity,
          );
          return LiveProductCard(
            name: product.productName,
            image: product.productImage[0],
            price: product.price,
            stocks: totalQuantity,
            rating: product.rating,
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            textColor: Theme.of(context).colorScheme.onSecondary,
            onPressed: () {
              navigateWithSlideTransition(
                context: context,
                page: UpdateProductPage(
                  productId: product.id,
                ),
                onFetch: () => onFetch(),
              );
            },
          );
        },
      ),
    );
  }
}
