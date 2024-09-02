import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/shop/ui/shop_pages/my_products_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SellerPage extends StatelessWidget {
  const SellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // shop details
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Row(
              children: [
                // image
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/colet.jpeg"),
                ),

                // spacing
                const SizedBox(
                  width: 10,
                ),

                // shop name
                Text(
                  "Coco Shop",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),

          // spacing
          const SizedBox(
            height: 10,
          ),

          // order status
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Status",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            "View Sales History",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),

                          // spacing
                          const SizedBox(
                            width: 10,
                          ),

                          const Icon(Iconsax.arrow_right_3)
                        ],
                      ),
                    )
                  ],
                ),

                // spacing
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _myBox(
                      "Pending",
                      "02",
                      Theme.of(context).colorScheme.onSecondary,
                    ),
                    _myBox(
                      "To Prepare",
                      "02",
                      Theme.of(context).colorScheme.onSecondary,
                    ),
                    _myBox(
                      "To Deliver",
                      "02",
                      Theme.of(context).colorScheme.onSecondary,
                    ),
                    _myBox(
                      "Reviews",
                      "102",
                      Theme.of(context).colorScheme.onSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // spacing
          const SizedBox(
            height: 10,
          ),
          // my product label
          GestureDetector(
            onTap: () {
              navigateWithSlideTransition(
                  context: context, page: const MyProducts());
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "My Products",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Iconsax.arrow_right_3)
                ],
              ),
            ),
          ),

          // spacing
          const SizedBox(
            height: 20,
          ),

          // TODO: Displat all products here

          const Text(
            "Display all products here",
            style: TextStyle(
              color: Colors.black,
              fontSize: 50,
            ),
          )
        ],
      ),
    );
  }

  Widget _myBox(String label, String count, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),

          // spacing
          const SizedBox(
            height: 10,
          ),

          Text(
            label,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
