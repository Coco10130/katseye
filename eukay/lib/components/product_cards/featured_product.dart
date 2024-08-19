import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeaturedProduct extends StatelessWidget {
  final double height;
  final String name;
  final double price;
  final String image;
  final Color backgroundColor;
  final Color textColor;
  const FeaturedProduct({
    super.key,
    required this.height,
    required this.name,
    required this.price,
    required this.image,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 150;
    const double spacing = 10;
    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱",
    );

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              height: spacing - 5,
            ),

            // product name
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: "Poppins",
              ),
            ),

            // spacing
            const SizedBox(
              height: spacing - 5,
            ),

            // product price
            Text(
              formatCurrency.format(price),
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
