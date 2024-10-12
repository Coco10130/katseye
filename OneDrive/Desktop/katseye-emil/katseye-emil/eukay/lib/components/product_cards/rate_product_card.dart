import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RateProductCard extends StatelessWidget {
  final Color backgroundColor, textColor;
  final String productImage, productName, size;
  final double price;
  const RateProductCard({
    super.key,
    required this.productImage,
    required this.productName,
    required this.price,
    required this.size,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onPrimary;
    const double spacing = 5;

    String getSizeLabel(String size) {
      switch (size) {
        case "XS":
          return "Extra Small";
        case "S":
          return "Small";
        case "M":
          return "Medium";
        case "L":
          return "Large";
        case "XL":
          return "Extra Large";
        case "XXL":
          return "Double Extra Large";
        default:
          return "Unknown Size";
      }
    }

    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱ ",
    );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(productImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // product name
                  Text(
                    productName,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // spacing
                  const SizedBox(height: spacing),

                  // price
                  Text(
                    formatCurrency.format(price),
                    style: TextStyle(
                      color: textColor,
                      fontFamily: "Poppins",
                      fontSize: 14,
                    ),
                  ),

                  // spacing
                  const SizedBox(height: spacing),

                  // size
                  Text(
                    "Size: ${getSizeLabel(size)}",
                    style: TextStyle(
                      color: textColor,
                      fontFamily: "Poppins",
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
