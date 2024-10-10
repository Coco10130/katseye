import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesProductCard extends StatelessWidget {
  final Color backgroundColor;
  final String image, productName, size;
  final int quantity;
  final double price;
  const SalesProductCard({
    super.key,
    required this.image,
    required this.productName,
    required this.size,
    required this.quantity,
    required this.price,
    this.backgroundColor = Colors.black,
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
                image: NetworkImage(image),
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

                  // spacing
                  const SizedBox(height: spacing),

                  // quantity
                  Text(
                    "Quantity: $quantity",
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
