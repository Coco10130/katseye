import 'package:eukay/components/product_cards/live_product_card.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:flutter/material.dart';

class ProductsBySeller extends StatelessWidget {
  final List<ProductModel> products;
  const ProductsBySeller({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridItemWidth = screenWidth > 1200 ? 300 : screenWidth * 0.4;

    final int crossAxisCount = (screenWidth / gridItemWidth).floor();
    final double productSpacing = screenWidth > 1200 ? 50 : 10;

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
          return LiveProductCard(
            name: product.productName,
            image: product.productImage[0],
            price: product.price,
            stocks: product.quantity,
            rating: product.rating,
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            textColor: Theme.of(context).colorScheme.onSecondary,
            onPressed: () {},
          );
        },
      ),
    );
  }
}
