import 'package:flutter/material.dart';

class ProductReviewContainer extends StatelessWidget {
  final int starRating;
  final String image, name, reviewMessage;
  const ProductReviewContainer({
    super.key,
    required this.image,
    required this.reviewMessage,
    required this.name,
    required this.starRating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // profile, name, star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // profile picture
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  backgroundImage: NetworkImage(image),
                ),

                // spacing
                const SizedBox(width: 10),

                // name and star rating
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // display star rating
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < starRating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFA534),
                          size: 17,
                        );
                      }),
                    ),
                  ],
                )
              ],
            ),

            // display review message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                reviewMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontFamily: "Poppins",
                  fontSize: 13,
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
