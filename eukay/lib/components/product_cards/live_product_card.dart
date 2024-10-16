import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveProductCard extends StatelessWidget {
  final Color backgroundColor, textColor;
  final String name, image;
  final double price, rating;
  final int stocks;
  final VoidCallback onPressed;
  const LiveProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.stocks,
    required this.image,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 10;
    const double spacing = 5;
    final double parentWidth = MediaQuery.of(context).size.width;
    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱ ",
    );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          maxWidth: parentWidth * 0.4,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            border: Border.all(
              width: 1.5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// image
            Container(
              width: parentWidth,
              height: parentWidth > 1200 ? 200 : parentWidth * 0.35,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // spacing
            const SizedBox(height: spacing),

            // prodcut description
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // product name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: "Poppins",
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

                  // spacing
                  const SizedBox(height: spacing),

                  // stocks
                  Text(
                    "Stocks: $stocks",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Poppins",
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // spacing
                  const SizedBox(height: spacing),

                  // price and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency.format(price),
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // star icon
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 13,
                            ),

                            // spacing
                            const SizedBox(
                              width: 3,
                            ),

                            // rating
                            Text(
                              "$rating",
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontSize: 12,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
