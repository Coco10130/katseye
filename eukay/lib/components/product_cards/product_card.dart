import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String image;
  final String shop;
  final double rating;
  final double discount;
  final Color textColor;
  final VoidCallback onPressed;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.onPressed,
    required this.shop,
    required this.rating,
    required this.discount,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product image
            Stack(
              children: [
                Container(
                  width: parentWidth,
                  height: parentWidth > 1200 ? 200 : parentWidth * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius - 2),
                      topRight: Radius.circular(borderRadius - 2),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // discount
                if (discount >= 1) ...{
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.red,
                    child: Text(
                      "$discount %",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontFamily: "Poppins",
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                },
              ],
            ),

            // product descriptions
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: "Poppins",
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

                  // Spacing
                  const SizedBox(height: spacing),

                  // display shop
                  Text(
                    shop,
                    style: TextStyle(
                      fontSize: 11,
                      color: textColor,
                      fontFamily: "Poppins",
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

                  // spacing
                  const SizedBox(height: spacing),

                  // spacing
                  const SizedBox(height: spacing),

                  // price
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
                  // Product price
                ],
              ),
            ),
            // Product name
          ],
        ),
      ),
    );
  }
}
