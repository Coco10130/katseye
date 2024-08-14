import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class FeaturedProduct extends StatelessWidget {
  final double height;
  final String name;
  final double price;
  final String image;
  const FeaturedProduct(
      {super.key,
      required this.height,
      required this.name,
      required this.price,
      required this.image});

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 150;
    const double spacing = 10;
    final _formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱",
    );

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: const Color(0xFF373737),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: spacing,
            ),

            // product image
            Container(
              width: cardWidth - 20,
              height: height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(20),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // spacing
            const SizedBox(
              height: spacing,
            ),

            // product name
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                  fontFamily: "Poppins",
                ),
              ),
            ),

            // spacing
            const SizedBox(
              height: spacing - 5,
            ),

            // product price
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _formatCurrency.format(price),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
