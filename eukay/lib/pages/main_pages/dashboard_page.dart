import 'package:eukay/components/buttons/my_icon_button.dart';
import 'package:eukay/components/my_searchbox.dart';
import 'package:eukay/components/product_cards/featured_product.dart';
import 'package:eukay/pages/main_pages/check_out/cart_page.dart';
import 'package:eukay/pages/main_pages/profile_pages/profile_page.dart';
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

    void cart() {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CartPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }

    void profile() {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }

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
            onPressed: cart,
          ),

          // profile action button
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: profile,
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
                    iconColor: Theme.of(context).colorScheme.onPrimary,
                  ),

                  // spacing
                  const SizedBox(
                    width: spacing + 10,
                  ),

                  // pants icon
                  MyIconBUtton(
                    icon: "assets/icons/trousers.png",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.onPrimary,
                  ),

                  // spacing
                  const SizedBox(
                    width: spacing + 10,
                  ),

                  // shoe icon
                  MyIconBUtton(
                    icon: "assets/icons/tshirt.png",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.onPrimary,
                  ),

                  // spacing
                  const SizedBox(
                    width: spacing + 10,
                  ),

                  // underwear icon
                  MyIconBUtton(
                    icon: "assets/icons/trousers.png",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.onPrimary,
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
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: 0.75,
              ),
              itemCount: featuredProduct.length,
              itemBuilder: (context, index) {
                final product = featuredProduct[index];
                final double price = product["price"].toDouble();
                return FeaturedProduct(
                  height: 200, // Adjust height based on your design
                  name: product["title"]!,
                  image: product["image"]!,
                  price: price,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
