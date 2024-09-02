import 'package:eukay/components/my_searchbox.dart';
import 'package:eukay/components/product_cards/product_card.dart';
import 'package:eukay/pages/search/ui/view_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchedPage extends StatelessWidget {
  const SearchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        "title": "Stylish Shoe",
        "price": 9999,
        "image": "assets/images/shoe.jpg",
      },
      {
        "title": "Stylish Shirt",
        "price": 499,
        "image": "assets/images/shirt.png",
      },
      {
        "title": "Black shirt",
        "price": 499,
        "image": "assets/images/colet.jpeg",
      },
      {
        "title": "Stylish Shoe",
        "price": 9999,
        "image": "assets/images/shoe.jpg",
      },
      {
        "title": "Stylish Shirt",
        "price": 499,
        "image": "assets/images/shirt.png",
      },
      {
        "title": "Black shirt",
        "price": 499,
        "image": "assets/images/colet.jpeg",
      },
      {
        "title": "Stylish Shoe",
        "price": 9999,
        "image": "assets/images/shoe.jpg",
      },
      {
        "title": "Stylish Shirt",
        "price": 499,
        "image": "assets/images/shirt.png",
      },
      {
        "title": "Black shirt",
        "price": 499,
        "image": "assets/images/colet.jpeg",
      },
      {
        "title": "Stylish Shoe",
        "price": 9999,
        "image": "assets/images/shoe.jpg",
      },
      {
        "title": "Stylish Shirt",
        "price": 499,
        "image": "assets/images/shirt.png",
      },
      {
        "title": "Black shirt",
        "price": 499,
        "image": "assets/images/colet.jpeg",
      },
    ];
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
            label: "Searched product",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SearchedBody(
        products: products,
      ),
    );
  }
}

class SearchedBody extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const SearchedBody({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridItemWidth = screenWidth > 1200 ? 300 : screenWidth * 0.4;

    final int crossAxisCount = (screenWidth / gridItemWidth).floor();
    final double productSpacing = screenWidth > 1200 ? 50 : 10;

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
            final double price = product["price"].toDouble();
            return ProductCard(
              name: product["title"]!,
              image: product["image"]!,
              price: price,
              shop: "shop name",
              rating: 4.6,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
              onPressed: () {
                Get.to(const ViewProduct());
              },
            );
          },
        ),
      ),
    );
  }
}
