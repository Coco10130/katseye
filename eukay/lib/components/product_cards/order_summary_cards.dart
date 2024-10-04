import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderSummaryContainer extends StatelessWidget {
  final Color backgroundColor, textColor;
  final String productName, size;
  final int quantity;
  final double price;
  final String image;
  const OrderSummaryContainer({
    super.key,
    required this.image,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.size,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    const double spacing = 10;

    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱ ",
    );

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // spacing
            const SizedBox(width: spacing),

            // product details
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // prodcut name
                  Text(
                    productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  // spacing
                  const SizedBox(height: spacing - 7),

                  // product size
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Size: ${getSizeLabel(size)}",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),

                  // spacing
                  const SizedBox(height: spacing - 7),

                  // quantity
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Quantity: 69",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),

                  // spacing
                  const SizedBox(height: spacing - 7),

                  //? price
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      formatCurrency.format(price),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //! delete icon
          ],
        ),
      ),
    );
  }
}
