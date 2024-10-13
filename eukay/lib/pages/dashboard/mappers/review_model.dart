class ReviewModel {
  final int starRating;
  final String review, productName, userName, userImage, productImage, id;

  const ReviewModel({
    required this.id,
    required this.starRating,
    required this.review,
    required this.userName,
    required this.userImage,
    required this.productName,
    required this.productImage,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["_id"],
      starRating: json["starRating"],
      review: json["review"],
      userName: json["userName"],
      userImage: json["userImage"],
      productName: json["productName"],
      productImage: json["productImage"],
    );
  }
}
