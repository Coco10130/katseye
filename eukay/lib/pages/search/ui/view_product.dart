import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ViewProduct extends StatelessWidget {
  const ViewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          // cart action button
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(
                  Iconsax.heart,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {},
              )),
        ],
      ),
      body: const BodyPage(),
    );
  }
}

class BodyPage extends StatelessWidget {
  const BodyPage({super.key});

  @override
  Widget build(BuildContext context) {
    const EdgeInsets edgePadding = EdgeInsets.symmetric(horizontal: 10);
    const double spacing = 10;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // product image
          Container(
            height: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/colet.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // spacing
          const SizedBox(
            height: spacing,
          ),

          // product name
          const Padding(
            padding: edgePadding,
            child: Text(
              "Product Name",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 0.7,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // star icon
                  Icon(
                    Iconsax.star1,
                    color: Colors.amber,
                    size: 20,
                  ),

                  // spacing
                  SizedBox(
                    width: 8,
                  ),

                  // rating score
                  Text(
                    "5.0",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // spacing
          const SizedBox(
            height: spacing,
          ),

          // description
          Padding(
            padding: edgePadding,
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),

          // spacing
          const SizedBox(
            height: spacing,
          ),

          // price
          const Padding(
            padding: edgePadding,
            child: Text(
              "P 909,88",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _size(String size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.5,
          color: const Color(0xFF252525),
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 20,
        child: Text(
          size,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "Poppins"),
        ),
      ),
    );
  }
}
