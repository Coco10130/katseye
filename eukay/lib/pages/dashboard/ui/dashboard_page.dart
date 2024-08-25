import 'package:eukay/components/buttons/my_icon_button.dart';
import 'package:eukay/components/my_searchbox.dart';
import 'package:eukay/components/product_cards/product_card.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/cart/ui/cart_page.dart';
import 'package:eukay/pages/profile/ui/profile_page.dart';
import 'package:eukay/pages/search_page/ui/search_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> featuredProducts = [
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
          IconButton(
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

          // profile action button
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                navigateWithSlideTransition(
                  context: context,
                  page: const ProfilePage(),
                );
              },
              icon: const ImageIcon(
                AssetImage("assets/icons/user.png"),
                size: 24,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
      body: DashboardBody(featuredProduct: featuredProducts),
    );
  }
}

class DashboardBody extends StatelessWidget {
  final List<Map<String, dynamic>> featuredProduct;
  const DashboardBody({super.key, required this.featuredProduct});

  @override
  Widget build(BuildContext context) {
    const double spacing = 20;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.onSecondary,
                  ),

                  // spacing
                  const SizedBox(
                    width: spacing + 10,
                  ),

                  // pants icon
                  MyIconBUtton(
                    icon: "assets/icons/trousers.png",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.onSecondary,
                  ),

                  // spacing
                  const SizedBox(
                    width: spacing + 10,
                  ),

                  // shoe icon
                  MyIconBUtton(
                    icon: "assets/icons/tshirt.png",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.onSecondary,
                  ),

                  // spacing
                  const SizedBox(
                    width: spacing + 10,
                  ),

                  // underwear icon
                  MyIconBUtton(
                    icon: "assets/icons/trousers.png",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.onSecondary,
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: spacing - 10,
                mainAxisSpacing: spacing - 10,
                childAspectRatio: 0.74,
              ),
              itemCount: featuredProduct.length,
              itemBuilder: (context, index) {
                final product = featuredProduct[index];
                final double price = product["price"].toDouble();
                return ProductCard(
                  name: product["title"]!,
                  image: product["image"]!,
                  price: price,
                  shop: "shop name",
                  rating: 4.6,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  onPressed: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
