import 'package:flutter/material.dart';

class ReviewContainer extends StatelessWidget {
  final String userImage, userName, review, productImage, productName;
  final int starRating;
  const ReviewContainer({
    super.key,
    required this.userImage,
    required this.userName,
    required this.review,
    required this.productImage,
    required this.productName,
    required this.starRating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // user details
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  backgroundImage: NetworkImage(userImage),
                ),

                // spacing
                const SizedBox(width: 10),

                // user name and star rating
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // user name
                    Text(
                      userName,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // spacing
                    const SizedBox(height: 5),

                    // star rating
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < starRating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFA534),
                          size: 17,
                        );
                      }),
                    ),

                    // spacing
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),

            // review message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                review,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // spacing
            const SizedBox(height: 10),

            // product
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                color: Theme.of(context).colorScheme.onPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // product image
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(productImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // spacing
                    const SizedBox(width: 10),

                    // product name

                    Expanded(
                      child: Text(
                        productName,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
